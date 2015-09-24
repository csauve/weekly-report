# weekly-report
This project serves as a template for weekly report generation. Fork it and customize to meet your needs.

## Usage
You'll need [Node.js](https://nodejs.org/en/) and [gulp](http://gulpjs.com/) installed to run this.
```sh
$ git clone https://github.com/csauve/weekly-report.git
$ cd weekly-report
$ npm install
$ gulp
```

Running the gulp task will look for directories named like `YYYY-MM-DD`, and build their `index.md` files into `index.html` files.

Gulp then serves out of the current directory at [http://localhost:9001/](http://localhost:9001/). Reports can then be copied out of the page to distribute. Changes to source files will cause a rebuild of the page.
