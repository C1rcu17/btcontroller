<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="stylesheet" href="/static/bootstrap.min.css">
    <style type="text/css">
      .space-bott {
        margin-bottom: 5px;
        margin-right: 5px;
      }
    </style>
    <script src="/static/hammer.min.js"></script>
    <script src="/static/hammer-time.min.js"></script>
    <script src="/static/jquery-3.1.1.min.js"></script>
    <script src="/static/jquery.hammer.js"></script>
    <script src="/static/tether.min.js"></script>
    <script src="/static/bootstrap.min.js"></script>
    <title>{{title or 'No title'}}</title>
  </head>
  <body>
    <nav class="navbar navbar-toggleable-md navbar-light bg-faded">
      <button class="navbar-toggler navbar-toggler-right" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
      </button>
      <a class="navbar-brand" href="/">{{title or 'No title'}}</a>
      <div class="collapse navbar-collapse" id="navbarNav">
        <ul class="navbar-nav">
          <li class="nav-item active">
            <a class="nav-link" href="/directional/">Directional</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="/functions/">Functions</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="/console/">Console</a>
          </li>
        </ul>
      </div>
    </nav>
    <div class="container">
      {{!base}}
    </div>
  </body>
</html>
