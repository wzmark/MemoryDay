export const initRDB: (databaseDir: string) => void;
export const addRDB: (title: string, date: string, repeat: string, tag: string, top: string, reminderId: number) => void;
export const searchRDB: () => object;
export const changeRDB: (id: number, title: string, date: string, repeat: string, tag: string, top: string, reminderId: number) => void;
export const deleteRDB: (id: number) => void;
export const searchFiltered: (name: string, price: number) => object;
