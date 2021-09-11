import express, { Application, Request, Response, NextFunction } from 'express'
import Logger from './logger'

const port = Number(process.env.PORT || 3000)

const logRequest = (req: Request, _: Response, next: NextFunction) => {
  const { headers } = req
  Logger.error('This is an error log')
  Logger.warn('This is a warn log')
  Logger.info('This is a info log')
  Logger.http(`This is a http log:\n ${JSON.stringify(headers)}`)
  Logger.debug('This is a debug log')
  next()
}

const app: Application = express()
app.use(logRequest)

app.get('/', (_, res) => {
  res.send('Hello From Express With TypeScript')
})

app.listen(port, () => {
  console.log(`server started on port ${port}`)
})
