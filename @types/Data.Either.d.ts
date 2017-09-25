declare module "Data.Either" {
  export type Either<L, R> = { value0: L | R };

  export function isRight<T, U>(either: Either<T, U>): boolean;
  export function isLeft<T, U>(either: Either<T, U>): boolean;
  export function fromRight<T, U>(partial: any): (either: Either<T, U>) => U;
}
