"use strict";

var gulp            = require('gulp');
var connect         = require('gulp-connect');
var plumber         = require('gulp-plumber');
var marked 			= require('gulp-markdown-livereload');
var rename 			= require('gulp-rename');
//marked.setOptions({
  //renderer: new marked.Renderer(),
  //gfm: true,
  //tables: true,
  //breaks: false,
  //pedantic: false,
  //sanitize: true,
  //smartLists: true,
  //smartypants: false
//});



// ============== CONFIG ==============
var cfg = {
	src: {},
	build: {}
};

cfg.src.dir = './';
cfg.src.vim = './vim_summary.md';

cfg.build.dir = './build/';

// ============== MAIN ==============


//connect
gulp.task('connect', function () {
	connect.server({
		root: cfg.build.dir,
		livereload: true
	});
});


//vim_summary
gulp.task('vim', function() {
	console.log('gulp: vim');
	gulp.src(cfg.src.vim)	
		.pipe(plumber())
		.pipe(rename('./index.md'))
		.pipe(marked())
		.pipe(gulp.dest(cfg.build.dir))
		.pipe(connect.reload());
});


// watch
gulp.task('watch', function () {
    gulp.watch(cfg.src.vim, ['vim']);
});


// default
gulp.task('default', ['connect', 'vim', 'watch']);
