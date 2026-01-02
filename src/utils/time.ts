export function calculateAge(birthDateString: string): number {
  const today = new Date();
  const birth = new Date(birthDateString);

  const thisYearBday = new Date(
    today.getFullYear(),
    birth.getMonth(),
    birth.getDate()
  );

  return (
    today.getFullYear() - birth.getFullYear() - (today < thisYearBday ? 1 : 0)
  );
}
