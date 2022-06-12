import { User } from '@prisma/client';
import moment from 'moment';
import {
  createJwt, JwtUserInfo,
} from '../../util/jwt/createJwt';
import { prisma } from '../../util/prisma/prismaContext';
import { getUserByEmail } from '../helpers/getUserByEmail';
import { validatePassword } from '../helpers/validatePassword';

export type LoginInput = {
  email: string;
  password: string;
}

export async function loginUser(
  {
    email,
    password,
  }: LoginInput,
  withUser: boolean = false,
): Promise<User | string> {
  const loginDateTime = moment().utc();
  const user = await getUserByEmail(email);
  await validatePassword(password, user);
  const userInfo: JwtUserInfo = user;
  const uniqueId = `${user.id}-${loginDateTime.unix()}`;

  const accessToken = createJwt({
    ...userInfo,
    requestTimeUtcUnix: loginDateTime.unix(),
    uniqueId,
  });

  const result: User | string | null = await prisma.user.update({
    where: {
      id: user.id,
    },
    data: {
      lastLoggedInAt: loginDateTime.toDate(),
      accessToken: accessToken,
    },
    ...(withUser
        ? {}
        : {
          select: {
            accessToken: true
          },
        }
    ),
  });

  if (result === null) {
    throw new Error('Failed to update user');
  }

  return result;
}

