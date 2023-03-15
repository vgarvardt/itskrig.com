Django HTTP query array
25 Oct 13 20:13 +0200
django, http, python

+++

HTTP queries in `application/x-www-form-urlencoded` encoding type is simple key/value list and in the most cases this is enough. But sometimes it's required to send more complex data types. Lists are supported in Django HttpRequest out of the box, so `foo=1&foo=2` can be received as list with `request.get_list('foo')`. But there is one more thing that makes web-developer life easier and that is supported in PHP by default - passing arrays.

Array in PHP is powerful type, that combines Python's `list` and `dict` - keys can be both integer and string types, plus all types that can be casted to these (all but array and object). So query passed to PHP in the form `foo[bar]=1&foo[baz]=2&foo[100]=3` will be available as array by `$_REQUEST['foo']['bar']`, `$_REQUEST['foo']['baz']` and `$_REQUEST['foo'][100]`.

Django does not support this behavior and request values dictionary (`request.GET.dict()`) data looks like:

```python
{
    "foo[bar]": "1",
    "foo[baz]": "2",
    "foo[100]": "3",
}
```

So there is no way to call something like this: `request.GET.get('foo', {}).get('bar')` as only values like this available: `request.GET.get('foo[bar]')`.

I tried different workarounds to avoid queries it this form, but sometimes it's the most simple and obvious way to send data. Here is my solution for parsing this type of queries into dictionaries:

```python
class RequestDictMixin(object):
    def get_request_dict(self, query_dict, param):
        result = dict()
        all_params = query_dict.dict()
        for str_name in all_params:
            if str_name.startswith(param + '[') and str_name.endswith(']'):
                self._request_dict_val(result, re.findall(r'\[(\w+)\]', str_name), all_params.get(str_name))
        return result

    def _request_dict_val(self, result, keys, val):
        current_key = keys[0]
        if len(keys) < 2:
            result[current_key] = val
        else:
            if current_key not in result:
                result[current_key] = dict()
            self._request_dict_val(result[current_key], keys[1:], val)
```

And here is quick example on how to use this mixin to parse sample query I used:

```python
class FooView(RequestDictMixin, View):
    def get(self, request):
        foo = self.get_request_dict(request.GET, 'foo')
        # foo.get('bar') -> "1"
        # foo.get('baz') -> "2"
        # foo.get('100') -> "3"
```

Mixin can parse not only "single-dimensional requests", but multi-dimensional too:

```python
# foo[bar][baz]=1&foo[bar][100]=2&foo[200]=3
foo = self.get_request_dict(request.GET, 'foo')
# foo.get('bar', {}).get('baz') -> "1"
# foo.get('bar', {}).get('100') -> "2"
# foo.get('200') -> "3"
```
