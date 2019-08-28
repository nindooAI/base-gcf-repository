import { Request, Response } from 'express'

export function helloWorld (req: Request, res: Response) {
  if (req.method !== 'GET') return res.status(405).end()
  return res.send('Hello!')
}