import glob from 'glob'
const functionFiles = glob.sync(`${__dirname}/**/*.js`)

for (let functionPath of functionFiles) {
  if (functionPath.split('/').pop() === __filename) continue

  const func = require(functionPath)
  const functionName = Object.keys(func)[0]
  exports[functionName] = func[functionName]
}
