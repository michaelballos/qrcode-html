import { prisma } from '../../util/prisma/prismaContext';

export async function logoutUser(
  userId: string,
): Promise<void> {
  await prisma.user.update({
    where: {
      id: userId,
    }, data: {
      accessToken: null,
    },
  });

  return;
}
