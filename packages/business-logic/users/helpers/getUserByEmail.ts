import { prisma } from '../../util/prisma/prismaContext';

export async function getUserByEmail(email: string) {
  const user = await prisma.user.findUnique({
    where: {
      email,
    },
  });
  if (!user) {
    throw new Error('User not found');
  }
  return user;
}
