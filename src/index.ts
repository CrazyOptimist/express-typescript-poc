import express, { Application, Request, Response, NextFunction } from 'express'

const port = Number(process.env.PORT || 3000)

const logRequest = (req: Request, _: Response, next: NextFunction) => {
  const { headers } = req
  console.log(headers)
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
