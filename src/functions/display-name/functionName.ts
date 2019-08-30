import { Request, Response } from 'express'

export function functionName (_req: Request, res: Response) {
  return res.send('Hello!')
}
