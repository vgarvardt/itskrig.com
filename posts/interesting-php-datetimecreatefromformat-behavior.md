Interesting PHP DateTime::createFromFormat() behavior
07 Nov 13 14:13 +0200
php

+++

In PHP [DateTime::createFromFormat()](http://php.net/datetime.createfromformat) method has one non-obvious behavior that I recendtly discovered. The best way to show is give quick and simple example.

```php
$dateStr = '2013-11-07T16:48:98+0400';
$dt = DateTime::createFromFormat(DateTime::ISO8601, $dateStr);
var_dump($dt->format(DateTime::ISO8601));
```

My expectaion from evaluting this piece of code was `false` or `null` as seconds should be valid only for 00-59 range. But, as usually, reality (and PHP developers) has its own opinion. The output for this piece of code is `string(24) "2013-11-07T16:49:38+0400"`.


So, what PHP does - it treats 98 seconds as 1 minute and 38 seconds, and minutes are added to the written in string format. Same applies to hours (`2013-11-07T16:68:98+0400` => `2013-11-07T17:09:38+0400`), etc.

Added note on this behavior to the method name page.
