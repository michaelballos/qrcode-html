import { compare } from 'bcrypt';

export async function validatePassword(
  password: string,
  user: any,
) {
  const isValid = await compare(password,
    user.passwordHash,
  );
  if (!isValid) {
    throw new Error('Invalid password');
  }
}
