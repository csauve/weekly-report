var gulp = require("gulp");
var sass = require("gulp-sass");
var serve = require("gulp-serve");
var jade = require("gulp-jade");
var rename = require("gulp-rename");
var es = require("event-stream");
var Remarkable = require("remarkable");
var hljs = require("highlight.js");
var fs = require("fs");

var md = new Remarkable({
  html: true,
  linkify: true,
  breaks: true,
  highlight: function(str, lang) {
    return hljs.highlight(lang, str).value;
  }
});

function getDirectories() {
  return fs.readdirSync(".").filter(function(file) {
    return fs.statSync(file).isDirectory() &&
      file.match(/\d{4}-\d{2}-\d{2}/) &&
      fs.readdirSync(file).indexOf("index.md") != -1;
  });
}

gulp.task("generate", function() {
  var directories = getDirectories();

  var index = gulp.src("template.jade")
    .pipe(jade({locals: {
      title: "Weekly Reports",
      reports: directories
    }}))
    .pipe(rename("index.html"))
    .pipe(gulp.dest("."));

  var jobs = directories.map(function(dirName) {
    var mdSource = fs.readFileSync(dirName + "/index.md", "UTF-8");
    var html = md.render(mdSource);
    return gulp.src("template.jade")
      .pipe(jade({locals: {
        htmlContent: html,
        title: dirName,
        reports: directories
      }}))
      .pipe(rename("index.html"))
      .pipe(gulp.dest(dirName));
  });

  jobs.push(index)
  return es.merge(jobs);
});

gulp.task("serve", ["generate"], serve({
  root: ["."],
  port: "9001"
}));

gulp.task("default", ["serve"], function() {
  gulp.watch("**/index.md", ["generate"]);
  gulp.watch("style.scss", ["generate"]);
  gulp.watch("template.jade", ["generate"]);
});