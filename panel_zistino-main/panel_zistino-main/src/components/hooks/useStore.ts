import create from "zustand";

export const useStore: any = create((set: any): any => ({
  menuStatus: false,
  setMenuStatus: (status: boolean) =>
    set((state: any) => ({ ...state, menuStatus: status })),
}));
