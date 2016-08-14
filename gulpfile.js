"use strict";

var gulp    = require('gulp');
var connect = require('gulp-connect');
var plumber = require('gulp-plumber');
var marked  = require('gulp-markdown-livereload');
var rename  = require('gulp-rename');

var current_file = 'vimscript_summary.md';

// ============== CONFIG ==============
var cfg = {
	src: {},
	build: {}
};

cfg.src.dir = './';

cfg.build.dir = './build/';

// ============== MAIN ==============


//connect
gulp.task('connect', function () {
	connect.server({
		root: cfg.build.dir,
    livereload: true,
    port: 3000
	});
});


//vim_summary
gulp.task('markdown', function() {
	gulp.src(current_file)
		.pipe(plumber())
		.pipe(rename('./index.md'))
		.pipe(marked())
		.pipe(gulp.dest(cfg.build.dir))
		.pipe(connect.reload());
});


// watch
gulp.task('watch', function () {
  gulp.watch(current_file, ['markdown']);
});


// default
gulp.task('default', ['connect', 'markdown', 'watch']);
