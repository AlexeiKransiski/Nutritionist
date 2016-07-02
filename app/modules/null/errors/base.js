import errors from 'errors'

errors.create({
  name: 'RuntimeError',
  code: 500,
  defaultMessage: 'A runtime error occurred during processing'
})

export default errors
