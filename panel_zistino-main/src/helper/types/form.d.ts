interface IChildrenEntries {
  label: string;
  name?: string;
  type: "select" | "input" | "textarea" | "file";
  options?: IChildrenEntriesOptions[];
}

interface IChildrenEntriesOptions {
  title: string;
  value: string | number;
}
