import { User } from '@prisma/client';
import { hash } from 'bcrypt';
import { prisma } from '../../util/prisma/prismaContext';

export type RegisterInput = {
  name: string;
  email: string;
  password: string;
  company: string;
  profilePicture: string | null;
}

async function register(
  {
    name,
    email,
    password,
    company,
    profilePicture,
  }: RegisterInput,
  withAccessToken: boolean = false,
  withInitialProject: boolean = false,
): Promise<User> {
  if (withAccessToken) {
    throw new Error(
      'Access token initialization are not implemented yet.'
    );
  }
  if (withInitialProject) {
    throw new Error(
      'Project initialization are not implemented yet.'
    );
  }

  const passwordHash = await hash(password, 10);

  return prisma.user.create({
    data: {
      name,
      email,
      company,
      passwordHash,
      profilePicture,
    },
  });
}
