wintersmith-nap
===============

Minimalistic plugin to connect wintersmith with nap

## Usage
In wintersmith's `config.json`, add `wintersmith-nap` to your plugins array, and provide nap config inside `nap` key:

```json
{
  "locals": {
    "title": "My Amazing Static Site!"
  },
  "plugins": ["wintersmith-nap"],
  "nap": {
    "assets": {
      "css": {
        "main": ["/css/*"]
      },
      "js": {
        "main": ["/js/*"]
      }
    }
  }
}
```

Next, in your template files, probably layout, you can call `nap` to output your assets links:

```jade
!!! 5
html(lang='en')
  head
    meta(charset='utf-8')
    title= locals.title
    != nap.css('main')
  body
    h1= title
    != nap.js('main')
```
That's it!

___

*For a production website as an example, refer to [etabits/website](https://github.com/etabits/website/)*
