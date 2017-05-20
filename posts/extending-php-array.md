Extending PHP array
24 Oct 13 00:31 +0200
php, array, OOP, ArrayObject

+++

Array is one of the most powerful and most used type in PHP. Actually this type combines functinality that other programming languages includes in different types. These types are *linear array* - `list` type in terms of Python or `List` interface in terms of Java and *associative array* - `dict`, or more likely `OrderedDict`, in terms of Python or `HashMap` in terms of Java.

But sometimes array behavior should be extended for better programmign experience, cleaner code and logic. For example, here is piece fo code that can be found in many projects:

```php
$foo = isset($array['foo']) ? $array['foo'] : null;
$bar = isset($array['bar']) ? $array['bar'] : null;
```

One of the ways to make this code shorter and better looking is short ternary operator:

```php
$foo = $array['foo'] ? : null;
$bar = $array['bar'] ? : null;
```

But this code throws undefined index php notice and I prefer my code to be as clean as possible, `error_reporting = E_ALL`. This is the situation when [ArrayObject](http://php.net/manual/en/class.arrayobject.php) comes to the rescue - objects of this class support array operations synthax but allows to change array behavior using inheritance.

In the project I currently work for (one of the backend services for [lamoda.ru](http://lamoda.ru)) I created three `ArrayObject` inheritors with different behaviors. They are:

* `DefaultingArrayObject` - returns default value when key does not exist in array
* `ExceptionArrayObject` - throws exception when key does not exist in array
* `CallbackArrayObject` - array values are Closures that are called and its result is returned as array value

## DefaultingArrayObject

This array type tries to do almost the same thing as Python's `defaultdict` or `dict.get(key, default)` do - if the key does not exist in array default value is returned. Full class listing:

```php
class DefaultingArrayObject extends \ArrayObject
{
    protected $default = null;

    public function offsetGet($index)
    {
        if (!is_null($index) && $this->offsetExists($index)) {
            return parent::offsetGet($index);
        } else {
            return $this->getDefault();
        }
    }

    /**
     * @param mixed $default
     * @return $this
     */
    public function setDefault($default)
    {
        $this->default = $default;
        return $this;
    }

    /**
     * @return mixed
     */
    public function getDefault()
    {
        return $this->default;
    }
}
```

Code example we use can be modified as:

```php
// if you need original array get it with $array->getArrayCopy()
$array = new DefaultingArrayObject($array);
$foo = $array['foo'];
$bar = $array['bar'];
```

## ExceptionArrayObject

As I mentioned before, php raises notice when key does not exist in the array. But sometimes I want to check several array keys existance before doing some logic. E.g.:

```php
if (isset($array['foo']) && isset($array['bar'])) {
    // logic that uses foo and bar array values
} else {
    // logic that does not use foo and bar array values
}
```

With my helper array object I can do the following:

```php
// if you need original array get it with $array->getArrayCopy()
$array = new ExceptionArrayObject($array);
try {
    // logic that uses foo and bar array values
} catch (UndefinedIndexException $e) {
    // logic that does not use foo and bar array values
}
```

Full class and exception listings:

```php
class ExceptionArrayObject extends \ArrayObject
{
    public function offsetGet($index)
    {
        if ($this->offsetExists($index)) {
            return parent::offsetGet($index);
        } else {
            throw new UndefinedIndexException($index);
        }
    }
}
```

```php
class UndefinedIndexException extends \Exception
{
    protected $index;

    public function __construct($index)
    {
        $this->index = $index;
        parent::__construct('Undefined index "' . $index . '"');
    }

    /**
     * @return string
     */
    public function getIndex()
    {
        return $this->index;
    }
}
```

## CallbackArrayObject

Use case for this array object does not seem to be obvious, so I'll describe real situation where I use this.

Project has global Logger object, that can be got from `ServiceLocator` (this is Zend Framework 2 project). Logger has several writers (files, stdout, sentry) but not all of them are used all the time. Logger initializer reads values from config and decides what writers it need for current request. E.g. SOAP request has it's own writers, admin panel - another writers, differet cli (command line) commands has different writers, etc. So we have config like this:

```php
return [
    'logging' => [
        'cli' => [
            'report foo' => [
                'stream' => 'DEBUG',
                'reports' => 'INFO',
            ],
            'report bar' => [
                'stream' => 'DEBUG',
                'reports' => 'INFO',
            ],
            'export foo' => [
                'stream' => 'DEBUG',
                'export' => 'ALERT',
            ],
        ],
        'web' => [
            'soap' => [
                'soap' => 'DEBUG',
            ],
            'admin' => [
                'admin' => 'INFO',
            ],
        ],
        'default' => [
        	'app' => 'INFO',
        ],
        'error' => [
            'err', 'sentry'
        ],
    ],
];
```

Now we have to define writers - all of them has names (stream, reports, export, soap, etc.), so array seems to be good candidate for writers storage, but we can put only writer object here, so all of them need to be initialized, all handlers must be open and ready fot use (lazy handlers initialization is an option, but we'll skip it here). So we need to initialize writers on demand. Here is how I implemented this:

```php
return [
	'logging' => [
        'writer' => new CallbackArrayObject([
            'stream' => function () {
                return new Zend\Log\Writer\Stream('php://output');
            },
            'app' => function () {
                return new Zend\Log\Writer\Stream('data/log/app.log');
            },
            'err' => function () {
                return new Zend\Log\Writer\Stream('data/log/error.log');
            },
            ...
        ]),
    ],
];
```

And array object listing is:

```php
class CallbackArrayObject extends \ArrayObject
{
    protected $initialized = array();

    public function __construct(array $values)
    {
        foreach ($values as $key => $value) {
            if (!($value instanceof \Closure)) {
                throw new \RuntimeException('Value for CallbackArrayObject must be callback for key ' . $key);
            }
        }
        parent::__construct($values);
    }

    public function offsetGet($index)
    {
        if (!isset($this->initialized[$index])) {
            $this->initialized[$index] = $this->getCallbackResult(parent::offsetGet($index));
        }
        return $this->initialized[$index];
    }

    protected function getCallbackResult(\Closure $callback)
    {
        return call_user_func($callback);
    }
}
```

So now I can initialize only required writers, e.g. stream by calling `$config['logging']['writer']['stream']`.
