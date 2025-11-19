export const jsonDecode = (str: string) => {
  const data = str?.replace(/'/g, '"');
  return data && JSON?.parse(data);
};
