const fs = require('fs')

function build() {
  const plugins = fs.readdirSync('plugins')
  plugins.forEach((plugin) => {
    const content = fs.readdirSync(`plugins/${plugin}`)
    if (content.includes('web')) {
      const config = JSON.parse(fs.readFileSync(`plugins/${plugin}/plugin.json`, { encoding: 'utf-8' }))

      if (config.isPersistent) {
      } else {
        copyDirectory(`plugins/${plugin}/web`, `web/pages/${plugin}`)
      }
    }
  })
}

async function copyDirectory(src, dest) {
  const [entries] = await Promise.all([
    fs.promises.readdir(src, { withFileTypes: true }),
    fs.promises.mkdir(dest, { recursive: true }),
  ])

  await Promise.all(
    entries.map((entry) => {
      const srcPath = path.join(src, entry.name)
      const destPath = path.join(dest, entry.name)
      return entry.isDirectory() ? copyDirectory(srcPath, destPath) : fs.promises.copyFile(srcPath, destPath)
    })
  )
}

function copy(src, dest) {
  if (fs.statSync(src).isDirectory()) {
    console.log('copying directory:', src)

    copyDirectory(src, dest).then(() => {
      console.log('copied directory:', src, '->', dest)
    })

    return
  }

  fs.copyFile(src, dest, (err) => {
    if (!err) {
      console.log('copied', src, '->', dest)
      return
    }

    console.error('failed to copy', src, 'err:', err)
    process.exit(-1)
  })
}

build()
