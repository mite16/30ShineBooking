const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const User = require('../models/User');

function signToken(user) {
  return jwt.sign({ sub: user._id.toString() }, process.env.JWT_SECRET, {
    expiresIn: process.env.JWT_EXPIRES_IN || '7d',
  });
}

async function register(req, res) {
  const { fullName, phone, email, password } = req.body;

  if (!fullName || !phone || !email || !password) {
    return res.status(400).json({ message: 'Thiếu thông tin bắt buộc' });
  }
  if (password.length < 6) {
    return res.status(400).json({ message: 'Mật khẩu tối thiểu 6 ký tự' });
  }

  const existing = await User.findOne({ $or: [{ email }, { phone }] });
  if (existing) {
    return res.status(409).json({ message: 'Email hoặc số điện thoại đã được sử dụng' });
  }

  const passwordHash = await bcrypt.hash(password, 10);
  const user = await User.create({ fullName, phone, email, passwordHash });

  return res.status(201).json({
    token: signToken(user),
    user: user.toPublicJSON(),
  });
}

async function login(req, res) {
  const { emailOrPhone, password } = req.body;

  if (!emailOrPhone || !password) {
    return res.status(400).json({ message: 'Thiếu email/số điện thoại hoặc mật khẩu' });
  }

  const user = await User.findOne({
    $or: [{ email: emailOrPhone.toLowerCase() }, { phone: emailOrPhone }],
  });
  if (!user) {
    return res.status(401).json({ message: 'Sai email/số điện thoại hoặc mật khẩu' });
  }

  const matches = await bcrypt.compare(password, user.passwordHash);
  if (!matches) {
    return res.status(401).json({ message: 'Sai email/số điện thoại hoặc mật khẩu' });
  }

  return res.json({
    token: signToken(user),
    user: user.toPublicJSON(),
  });
}

async function me(req, res) {
  const user = await User.findById(req.userId);
  if (!user) return res.status(404).json({ message: 'Không tìm thấy người dùng' });
  return res.json({ user: user.toPublicJSON() });
}

module.exports = { register, login, me };
