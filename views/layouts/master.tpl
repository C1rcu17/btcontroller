<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no, shrink-to-fit=no">
    <style>
      html, body {
        margin: 0px;
        padding: 0px;
        height: 100%;
      }
    </style>
    %if defined('styles'):
      %styles()
    %end
    <script src="/static/hammer.min.js"></script>
    <script src="/static/hammer-time.min.js"></script>
    <script src="/static/jquery-3.1.1.min.js"></script>
    %if defined('scripts'):
      %scripts()
    %end
    <title>{{title or 'No title'}}</title>
  </head>
  <body>
    {{!base}}
  </body>
</html>
