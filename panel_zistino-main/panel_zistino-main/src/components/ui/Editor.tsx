import { FC } from "react";
import { EditorContent } from "@tiptap/react";

export const Editor: FC<any> = ({ editor, label }) => {
  return (
    <>
      <label className="label mb-2">
        <span className="label-text dark:text-gray-200 text-gray-500">
          {label}
        </span>
      </label>
      <div className="bg-[#f1f1f1] text-gray-700 dark:bg-[#3d4451] dark:text-gray-300 px-5 pt-2 pb-5 rounded-xl">
        <Menu editor={editor} />
        <EditorContent editor={editor} />
      </div>
    </>
  );
};

const Menu = ({ editor }: { editor: any }) => {
  if (!editor) {
    return null;
  }

  return (
    <div className="space-x-3 space-y-3 space-x-reverse">
      <button
        type="button"
        onClick={() => editor.chain().focus().toggleBold().run()}
        className={
          editor.isActive("bold")
            ? "border-2 border-gray-500 bg-zinc-300 dark:bg-gray-800/50 px-2 py-0.5 rounded-xl text-sm mr-3"
            : "border-2 border-transparent bg-zinc-300 dark:bg-gray-800/50 px-2 py-0.5 rounded-xl text-sm mr-3"
        }
      >
        bold
      </button>
      <button
        type="button"
        onClick={() => editor.chain().focus().toggleItalic().run()}
        className={
          editor.isActive("italic")
            ? "border-2 border-gray-500 bg-zinc-300 dark:bg-gray-800/50 px-2 py-0.5 rounded-xl text-sm mr-3"
            : "border-2 border-transparent bg-zinc-300 dark:bg-gray-800/50 px-2 py-0.5 rounded-xl text-sm mr-3"
        }
      >
        italic
      </button>
      {/* <button
        type="button"onClick
        ={() => editor.chain().focus().setParagraph().run()}
        className={
          editor.isActive("paragraph")
            ? "border-2 border-gray-500 bg-gray-800/50 px-2 py-0.5 rounded-xl text-sm"
            : "border-2 border-transparent bg-gray-800/50 px-2 py-0.5 rounded-xl text-sm"
        }
      >
        paragraph
      </button> */}
      <button
        type="button"
        onClick={() => editor.chain().focus().toggleHeading({ level: 1 }).run()}
        className={
          editor.isActive("heading", { level: 1 })
            ? "border-2 border-gray-500 bg-zinc-300 dark:bg-gray-800/50 px-2 py-0.5 rounded-xl text-sm mr-3"
            : "border-2 border-transparent bg-zinc-300 dark:bg-gray-800/50 px-2 py-0.5 rounded-xl text-sm mr-3"
        }
      >
        h1
      </button>
      <button
        type="button"
        onClick={() => editor.chain().focus().toggleHeading({ level: 2 }).run()}
        className={
          editor.isActive("heading", { level: 2 })
            ? "border-2 border-gray-500 bg-zinc-300 dark:bg-gray-800/50 px-2 py-0.5 rounded-xl text-sm mr-3"
            : "border-2 border-transparent bg-zinc-300 dark:bg-gray-800/50 px-2 py-0.5 rounded-xl text-sm mr-3"
        }
      >
        h2
      </button>
      <button
        type="button"
        onClick={() => editor.chain().focus().toggleHeading({ level: 3 }).run()}
        className={
          editor.isActive("heading", { level: 3 })
            ? "border-2 border-gray-500 bg-zinc-300 dark:bg-gray-800/50 px-2 py-0.5 rounded-xl text-sm mr-3"
            : "border-2 border-transparent bg-zinc-300 dark:bg-gray-800/50 px-2 py-0.5 rounded-xl text-sm mr-3"
        }
      >
        h3
      </button>
      <button
        type="button"
        onClick={() => editor.chain().focus().toggleHeading({ level: 4 }).run()}
        className={
          editor.isActive("heading", { level: 4 })
            ? "border-2 border-gray-500 bg-zinc-300 dark:bg-gray-800/50 px-2 py-0.5 rounded-xl text-sm mr-3"
            : "border-2 border-transparent bg-zinc-300 dark:bg-gray-800/50 px-2 py-0.5 rounded-xl text-sm mr-3"
        }
      >
        h4
      </button>
      <button
        type="button"
        onClick={() => editor.chain().focus().toggleHeading({ level: 5 }).run()}
        className={
          editor.isActive("heading", { level: 5 })
            ? "border-2 border-gray-500 bg-zinc-300 dark:bg-gray-800/50 px-2 py-0.5 rounded-xl text-sm mr-3"
            : "border-2 border-transparent bg-zinc-300 dark:bg-gray-800/50 px-2 py-0.5 rounded-xl text-sm mr-3"
        }
      >
        h5
      </button>
      <button
        type="button"
        onClick={() => editor.chain().focus().toggleHeading({ level: 6 }).run()}
        className={
          editor.isActive("heading", { level: 6 })
            ? "border-2 border-gray-500 bg-zinc-300 dark:bg-gray-800/50 px-2 py-0.5 rounded-xl text-sm mr-3"
            : "border-2 border-transparent bg-zinc-300 dark:bg-gray-800/50 px-2 py-0.5 rounded-xl text-sm mr-3"
        }
      >
        h6
      </button>
      <button
        type="button"
        onClick={() => editor.chain().focus().toggleBulletList().run()}
        className={
          editor.isActive("bulletList")
            ? "border-2 border-gray-500 bg-zinc-300 dark:bg-gray-800/50 px-2 py-0.5 rounded-xl text-sm mr-3"
            : "border-2 border-transparent bg-zinc-300 dark:bg-gray-800/50 px-2 py-0.5 rounded-xl text-sm mr-3"
        }
      >
        list
      </button>
      <button
        type="button"
        onClick={() => editor.chain().focus().toggleOrderedList().run()}
        className={
          editor.isActive("orderedList")
            ? "border-2 border-gray-500 bg-zinc-300 dark:bg-gray-800/50 px-2 py-0.5 rounded-xl text-sm mr-3"
            : "border-2 border-transparent bg-zinc-300 dark:bg-gray-800/50 px-2 py-0.5 rounded-xl text-sm mr-3"
        }
      >
        ordered list
      </button>
      {/* <button
        type="button"
        onClick={() => editor.chain().focus().toggleCodeBlock().run()}
        className={
          editor.isActive("codeBlock")
            ? "border-2 border-gray-500 bg-gray-800/50 px-2 py-0.5 rounded-xl text-sm"
            : "border-2 border-transparent bg-gray-800/50 px-2 py-0.5 rounded-xl text-sm"
        }
      >
        code
      </button> */}
      <button
        type="button"
        onClick={() => editor.chain().focus().toggleBlockquote().run()}
        className={
          editor.isActive("blockquote")
            ? "border-2 border-gray-500 bg-zinc-300 dark:bg-gray-800/50 px-2 py-0.5 rounded-xl text-sm mr-3"
            : "border-2 border-transparent bg-zinc-300 dark:bg-gray-800/50 px-2 py-0.5 rounded-xl text-sm mr-3"
        }
      >
        blockquote
      </button>
    </div>
  );
};
