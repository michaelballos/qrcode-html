import jwt from 'jsonwebtoken';
import moment from 'moment';
import { getEnvVar } from '../../../util/getEnvVar';

export interface GenerateJwtInput {
  requestTimeUtcUnix: number;
  uniqueId: string;
  id: string;
  name: string;
  profilePicture: string | null;
  email: string;
}

export type JwtUserInfo = Omit<
  GenerateJwtInput,
  'uniqueId' | 'requestTimeUtcUnix'
>;

function createRegisteredClaims(
  userId: string,
  requestTimeUtcUnix: number,
  loginTokenDurationDays: string,
  uniqueId: string,
) {
  return {
    iss: 'https://dashboard.qrscribe.com',
    sub: userId,
    aud: 'https://api.qrscribe.com',
    exp: moment(requestTimeUtcUnix)
      .add(loginTokenDurationDays, 'day')
      .unix(),
    nbf: requestTimeUtcUnix,
    iat: moment().utc().unix(),
    jti: uniqueId,
  };
}

function createPublicClaims(
  fullName: string,
  profilePicture: string | null,
  email: string,
) {
  return {
    name: fullName,
    picture: profilePicture === null
      ? undefined
      : profilePicture,
    email,
  };
}

export function createJwt({
  id,
  requestTimeUtcUnix,
  uniqueId,
  name,
  profilePicture,
  email,
}: GenerateJwtInput): string {
  const loginTokenDurationDays = getEnvVar(
    'JWT_LOGIN_EXPIRES_IN'
  );
  const jwtSignSecret = getEnvVar('JWT_SECRET');
  const registeredClaims = createRegisteredClaims(
    id,
    requestTimeUtcUnix,
    loginTokenDurationDays,
    uniqueId,
  );
  const publicClaims = createPublicClaims(
    name,
    profilePicture,
    email,
  );
  return jwt.sign(
    { ...registeredClaims, ...publicClaims },
    jwtSignSecret,
    { algorithm: 'HS256' }
  );
}
