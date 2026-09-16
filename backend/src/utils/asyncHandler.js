// Wraps an async Express handler so a rejected promise reaches next(err)
// instead of crashing the process.
function asyncHandler(fn) {
  return (req, res, next) => fn(req, res, next).catch(next);
}

module.exports = { asyncHandler };
