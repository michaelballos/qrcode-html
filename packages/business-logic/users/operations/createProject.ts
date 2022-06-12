import { Project } from '@prisma/client';
import { prisma } from '../../util/prisma/prismaContext';

interface ProjectCreateInput {
  name: string;
  description: string;
}

/**
 * Creates a new project for the user with the given id.
 */
export async function createProject(
  userId: string,
  {
    name,
    description,
  }: ProjectCreateInput): Promise<Project> {
    return await prisma.project.create({
      data: {
        name,
        description,
        owner: {
          connect: {
            id: userId,
          }
        }
      }
    });
  }
