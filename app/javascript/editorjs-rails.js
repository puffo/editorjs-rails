import EditorJS from "@editorjs/editorjs";
import Header from "@editorjs/header";
import ImageTool from "@editorjs/image";
import NestedList from "@editorjs/nested-list";
import Quote from "@editorjs/quote";
import RawTool from "@editorjs/raw";
import Delimiter from "@editorjs/delimiter";

// Inline tools
import Marker from "@editorjs/marker";
import InlineCode from "@editorjs/inline-code";
import Underline from "@editorjs/underline";
import Strikethrough from "@sotaproject/strikethrough";

if (!window.EditorJS) { window.EditorJS = {} }
if (!window.EditorJS.Rails) { window.EditorJS.Rails = { tools: {} } }

function initializeEditor(el) {
  const input = el.parentElement.querySelector(`#${el.dataset.input}`);
  const form = input.form;

  let data = {}

  try {
    data = JSON.parse(input.value)
  } catch (e) {
    console.error(e)
  }

  const editor = new EditorJS({
    holder: el,
    data,
    placeholder: 'Let\'s write an awesome story!',
    inlineToolbar: ['bold', 'italic', 'link', 'marker', 'underline', 'strikethrough', 'inlineCode'],
    tools: {
      header: {
        class: Header,
        inlineToolbar: true,
        config: {
          placeholder: 'Enter a header',
          levels: [1, 2, 3, 4, 5, 6],
          defaultLevel: 2
        },
        shortcut: 'CMD+ALT+H'
      },
      paragraph: {
        inlineToolbar: true,
      },
      image: {
        class: ImageTool,
        config: {
          endpoints: {
            byFile: el.dataset.uploadImageUrl,
            byUrl: el.dataset.uploadImageUrl,
          },
          additionalRequestData: {
            record_type: el.dataset.recordType,
            record_id: el.dataset.recordId,
            name: el.dataset.name,
            authenticity_token: el.dataset.authenticityToken,
          },
        }
      },
      list: {
        class: NestedList,
        inlineToolbar: true,
        shortcut: 'CMD+ALT+L'
      },
      quote: {
        class: Quote,
        inlineToolbar: true,
        shortcut: 'CMD+ALT+Q'
      },
      raw: RawTool,
      delimiter: Delimiter,
      // Inline tools
      marker: {
        class: Marker,
        shortcut: 'CMD+SHIFT+M',
      },
      inlineCode: {
        class: InlineCode,
        shortcut: 'CMD+SHIFT+C',
      },
      underline: {
        class: Underline,
        shortcut: 'CMD+SHIFT+U',
      },
      strikethrough: {
        class: Strikethrough,
        shortcut: 'CMD+SHIFT+S',
      },
      ...window.EditorJS.Rails.tools,
    },
  });

  form.addEventListener("submit", async () => {
    const data = await editor.save();
    input.value = JSON.stringify(data);
  });
}

// Initialize on Turbo load (for Rails Turbo support)
document.addEventListener("turbo:load", () => {
  document.querySelectorAll(".editorjs").forEach(initializeEditor);
});

// Export for manual initialization
export { initializeEditor };
export default EditorJS;