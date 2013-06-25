fs = require("fs")
path = require("path")
match = require("match-files")
coffee = require("coffee-script")
jade = require("jade")
sty = require('sty')

directory = process.cwd()

console.info = (msg) ->
  console.log sty.red msg

console.debug = (msg) ->
  console.log sty.green msg



class Application
  constructor: ->
    @program = require('commander')
    @titanium = null

    @program
      .version('0.0.2')
      .option('-s, --setup', 'Setup lazy-alloy directory structure.')
      .option('-c, --compile', 'Just compile.')
      .option('-w, --watch', 'Watch file changes & compile.')
      .option('-p, --platform [platform]', 'Run titanium on `platform`')
      .option('-d, --directory [dirname]', 'Set source directory (default `src/`)')
      .parse(process.argv)

    @subfolder = @program.directory or 'src/'
    @compiler = new Compiler(@subfolder)

    return @setup() if @program.setup
    return @compile() if @program.compile
    return @watch() if @program.watch
    return @build() if @program.platform

    console.info "nothing to do!"

  compile: ->
    @compiler.all()

  build: ->
    spawn = require("child_process").spawn
    exec = require("child_process").exec

    if @titanium isnt null
      console.info "stopping titanium..."
      @titanium.kill()

    alloy = exec "alloy compile", (error, stdout, stderr) ->
      console.debug stdout if stdout
      console.log stderr if stderr

    alloy.on 'exit', (code) =>
      console.log "alloy stopped with code #{ code }"

      if code isnt 1
        console.info "starting titanium..."

        @titanium = spawn "titanium", ["build", "-p", @program.platform]

        @titanium.stdout.on "data", (data) ->
          console.log "titanium: " + data

        @titanium.stderr.on "data", (data) ->
          console.log "titanium: " + data

        @titanium.on "exit", (code) ->
          console.log "titanium exited with code " + code

  watch: ->
    watchr = require("watchr")

    console.info "Waiting for file change..."

    watchr.watch
      paths: [directory]
      listeners:
        error: (err) ->
          console.log "an error occured:", err

        change: (changeType, filePath, fileCurrentStat, filePreviousStat) =>
          return unless changeType in ["create", "update"]

          #only compile correct files
          file = getFileType filePath
          return unless file

          @compiler.files [filePath], file.fromTo[0], file.fromTo[1]

          @build() if @program.platform

    next: (err, watchers) ->
      if err
        return console.log("watching everything failed with error", err)
      else
        console.debug "Waiting for file change..."

  setup: ->
    @subfolder += '/' unless @subfolder.charAt(@subfolder.length-1) == '/'
    console.info 'Setting up folder structure...'
    @compiler.mkdirSync @subfolder
    @compiler.mkdirSync @subfolder+'views'
    @compiler.mkdirSync @subfolder+'styles'
    @compiler.mkdirSync @subfolder+'controllers'
    console.debug 'Setup complete.'

  getFileType = (path) ->
    #check if file path contains string
    inpath = (name) ->
      !!~ path.indexOf name

    return {type: "view", fromTo: ["jade", "xml"]} if inpath ".jade"

    return null unless inpath ".coffee"

    return {type: "style", fromTo: ["coffee", "tss"]} if inpath "styles/"
    return {type: "alloy", fromTo: ["coffee", "js"]} if inpath "alloy.coffee"
    return {type: "controller", fromTo: ["coffee", "js"]} if inpath "controllers/"

class Compiler
  logger: console
  constructor: (@subfolder = 'src/') ->

  views: ->
    @process "views/", "jade", "xml"

  controllers: ->
    @process "controllers/", "coffee", "js"

  styles: ->
    @process "styles/", "coffee", "tss"

  all: ->
    @views()
    @controllers()
    @styles()

  process: (path, from, to) ->
    path = @subfolder + path
    @logger.info "Preprocessing #{ from } files in #{ path }"

    filter = (dir) -> dir.indexOf(".#{ from }") isnt -1

    match.find (process.cwd() + "/" + path), {fileFilters: [filter]}, (err, files) => @files files, from, to

  file: (from, output, type) ->
    @logger.debug "Building #{type}: #{from} --> #{output}"
    data = fs.readFileSync from, 'utf8'
    compiled = @build[type] data
    fs.writeFileSync output, compiled, 'utf8'

  files: (files, from, to, to_path) ->
    return @logger.debug "No '*.#{from}' files need to preprocess.. #{files.length} files" if files.length is 0

    for file in files
      break if !!~ file.indexOf "lazyalloy"

      output = file.substring(0, file.length - from.length).toString() + to
      output = output.replace(new RegExp('(.*)'+@subfolder), '$1app/') # Replacing subfolder with app. Only last occurence in case it exists twice in the path.

      @file file, output, to

  mkdir: (path) ->
    if fs.existsSync(path) then console.debug("#{path} already exists, doing nothing") else fs.mkdirSync path

  build:
    xml: (data) ->
      jade.compile(data,
        pretty: true
      )(this)

    tss: (data) ->
      data = @js data

      (data.replace "};", "").replace """
        var tss;

        tss = {

        """, ""

    js: (data) ->
      coffee.compile data.toString(), {bare: true}


module.exports = new Application
