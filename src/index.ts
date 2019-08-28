import glob from 'glob'
import { dirname } from 'path'
import { Request, Response } from 'express'
const config = require('../package.json')
const functionFiles = glob.sync(`${__dirname}/!(dist)/*.js`)

type Verb = 'GET' | 'POST' | 'PATCH' | 'PUT' | 'DELETE'
interface FunctionConfig {
  trigger: {
    type: string
    name: string
  },
  methods: Verb[]
}

function wrap (fn: Function, fnConfig: FunctionConfig) {
  return (req: Request, res: Response) => {
    if (!fnConfig.methods.includes(req.method as Verb)) return res.status(405).end()
    return fn(req, res)
  }
}

for (let functionPath of functionFiles) {
  if (functionPath.split('/').pop() === __filename) continue

  const func = require(functionPath)
  const functionName = Object.keys(func)[0]
  const functionDir = dirname(functionPath).split('/').pop() as string
  const functionConfig = config.functionConfig[functionDir]
  console.log(functionDir, functionConfig)

  exports[functionName] = wrap(func[functionName], functionConfig)
}
