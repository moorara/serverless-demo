const fs = require('fs')
const path = require('path')
const Module = require('module')
const Archiver = require('archiver')

const JS_EXT = '.js'
const NODE_MODULES = 'node_modules'

function filterModules (modules) {
  const system = path.isAbsolute
  const duplicate = (item, pos, self) => self.indexOf(item) === pos

  const canonical = module => {
    const i = module.indexOf(NODE_MODULES)
    return i < 0 ? module : module.substring(0, module.indexOf('/', NODE_MODULES.length + i + 1))
  }

  return modules.filter(system).map(canonical).filter(duplicate)
}

function listModules (filepath) {
  let modules = []

  // Override require functionality
  const _require = Module.prototype.require
  Module.prototype.require = function (name) {
    const module = Module._resolveFilename(name, this)
    modules.push(module)
    return _require.call(this, module)
  }

  _require(filepath)
  modules = filterModules(modules)

  // Restore require functionality
  Module.prototype.require = _require

  return modules
}

function zipModules (filepath, modules, outpath) {
  const filename = path.basename(filepath)

  const archiver = Archiver('zip', {})
  archiver.on('error', console.log)
  archiver.on('warning', console.log)

  const output = fs.createWriteStream(path.resolve(__dirname, outpath))
  output.on('close', _ => console.log('packaging completed'))
  output.on('end', _ => console.log('data has been drained'))

  archiver.pipe(output)

  archiver.file(filepath, {
    name: filename
  })

  for (const module of modules) {
    if (module.indexOf(NODE_MODULES) > 0) {
      const destPath = `node_modules/${path.basename(module)}`
      archiver.directory(module, destPath)
    } else if (module.endsWith(JS_EXT)) {
      archiver.file(module, {
        name: path.basename(module)
      })
    }
  }

  archiver.finalize()
}

function main () {
  if (!process.argv[2]) {
    console.log('no source is specified!')
    process.exit()
  }

  if (!process.argv[3]) {
    console.log('no destination is specified!')
    process.exit()
  }

  // Resolve the absolute path to source file
  let filepath = path.resolve(__dirname, process.argv[2])
  if (!filepath.endsWith(JS_EXT)) {
    filepath = path.resolve(filepath, 'index.js')
  }

  // Resolve the absolute path to destination file
  const outpath = path.resolve(__dirname, process.argv[3])
  const basepath = path.dirname(outpath)
  if (!fs.existsSync(basepath)) {
    fs.mkdirSync(basepath)
  }

  const modules = listModules(filepath)
  zipModules(filepath, modules, outpath)
}

main()
