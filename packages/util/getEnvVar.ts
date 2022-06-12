export function getEnvVar(key: string) {
  const env = process.env;
  if (!env[key]) {
    throw new Error(`Environment variable ${key} is not set`);
  }
  return env[key] as string;
}
