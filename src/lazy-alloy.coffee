fs = require("fs")
path = require("path")
glob = require("glob")
coffee = require("coffee-script")
jade = require("jade")
sty = require('sty')

console.info = (msg) ->
  console.log sty.red msg

console.debug = (msg) ->
  console.log sty.green msg

class Application
  constructor: ->
    @program = require('commander')
    @compiler = new Compiler()

    @program
      .version('0.0.1')
      .option('-c, --compile', 'Just compile.')
      .option('-w, --watch', 'Watch file changes & compile.')
      .option('-p, --platform [platform]', 'Run titanium on `platform`')
      .parse(process.argv)

    return @compile() if @program.compile
    return @watch() if @program.watch
    return @build() if @program.platform

    console.info "nothing to do.. zzz"

  compile: ->
    @compiler.all()

  build: ->
    sys = require("sys")
    exec = require("child_process").exec

    sh = "titanium build -p #{ @program.platform }"
    console.log sh
    exec sh, (error, stdout, stderr) ->
      sys.puts stdout

  watch: ->
    watchr = require("watchr")

    console.info "Waiting for file change..."

    watchr.watch
      paths: [__dirname]
      listeners:
        error: (err) ->
          console.log "an error occured:", err

        change: (changeType, filePath, fileCurrentStat, filePreviousStat) =>
          return unless changeType in ["create", "update"]

          #only compile correct files
          file = @_getFileType filePath
          return unless file

          @compiler.files [filePath], file.fromTo[0], file.fromTo[1]

          #build only if asked
          @build() if @program.platform 

    next: (err, watchers) ->
      if err
        return console.log("watching everything failed with error", err)
      else
        console.debug "Waiting for file change..."

  _getFileType: (path) ->
    inpath = (name) ->
      !!~ path.indexOf name

    return {type: "view", fromTo: ["jade", "xml"]} if inpath ".jade"

    return null unless inpath ".coffee"

    return {type: "controller", fromTo: ["coffee", "js"]} if inpath "controllers/"
    return {type: "style", fromTo: ["coffee", "tss"]} if inpath "styles/"

class Compiler
  logger: console

  views: ->
    @process "/**/views/*.jade", "jade", "xml"
  
  controllers: ->
    @process "/**/controllers/*.coffee", "coffee", "js"

  styles: ->
    @process "/**/styles/*.coffee", "coffee", "tss"

  all: ->
    @views()
    @controllers()
    @styles()

  process: (path, from, to) ->
    @logger.info "Preprocessing #{ from } files in [project_root]#{ path.replace("/**", "/app") }"

    @files glob.sync(path,
      cwd: __dirname,
      root: __dirname,
      nosort: true,
      nonull: false,
    ), from, to

  file: (from, output, type) ->
    @logger.debug "Building #{type}: #{from} --> #{output}"
    data = fs.readFileSync from, 'utf8'
    compiled = @build[type] data
    fs.writeFileSync output, compiled, 'utf8'

  files: (files, from, to) ->
    return @logger.debug "No '*.#{from}' files need to preprocess.. #{files.length} files" if files.length is 0

    for file in files
      break if !!~ file.indexOf "lazyalloy"

      filenameWithNewExt = file.substring(0, file.length - from.length).toString() + "#{ to }"
      @file file, filenameWithNewExt, to

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
