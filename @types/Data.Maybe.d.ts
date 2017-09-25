declare module "Data.Maybe" {
  export type Maybe<T> = { value0?: T };

  export function isJust<T>(maybe: Maybe<T>): boolean;
  export function fromJust<T>(unused: any): (maybe: Maybe<T>) => T;
}
