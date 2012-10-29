fs = require("fs")
path = require("path")
glob = require("glob")
util = require("util")
coffee = require 'coffee-script'

_compile_coffee = (coffee_file, js_file) ->
  data = fs.readFileSync coffee_file, 'utf8'
  compiled = coffee.compile data
  fs.writeFileSync js_file, compiled, 'utf8'

exports.pre_compile = (event, logger) ->
  logger.info "----- COFFEEALLOY PREPROCESSOR -----"
  logger.info "Preprocessing CoffeeScript files in [project_root]/app/"
  coffee_files = glob.sync("/**/*.coffee",
    cwd: event.dir.home,
    root: event.dir.home,
    nosort: true,
    nonull: false,
  )
  
  logger.info "No '*.coffee' scripts need to preprocess" if coffee_files.length==0
  
  for coffee_file in coffee_files
    preprocessed = false
    coffee_timestamp = util.inspect(fs.lstat(coffee_file)).ctime
    js_file = coffee_file.substring(0, coffee_file.length - 6).toString() + "js"
    
    if fs.existsSync(js_file)
      js_timestamp = util.inspect(fs.lstat(js_file)).ctime
      preprocessed = (if coffee_timestamp > js_timestamp then false else true)
      
    if not preprocessed
      logger.info "- Preprocessing: " + path.relative(event.dir.project, coffee_file)
      _compile_coffee coffee_file, js_file
