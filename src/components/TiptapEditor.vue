<template>
  <div class="tiptap-editor">
    <div v-if="editor" class="editor-toolbar">
      <button 
        type="button"
        @click="editor.chain().focus().toggleBold().run()" 
        :class="{ 'is-active': editor.isActive('bold') }"
        class="toolbar-btn"
      >
        <i class="fas fa-bold"></i>
      </button>
      <button 
        type="button"
        @click="editor.chain().focus().toggleItalic().run()" 
        :class="{ 'is-active': editor.isActive('italic') }"
        class="toolbar-btn"
      >
        <i class="fas fa-italic"></i>
      </button>
      <button 
        type="button"
        @click="editor.chain().focus().toggleStrike().run()" 
        :class="{ 'is-active': editor.isActive('strike') }"
        class="toolbar-btn"
      >
        <i class="fas fa-strikethrough"></i>
      </button>
      
      <span class="toolbar-divider"></span>
      
      <button 
        type="button"
        @click="editor.chain().focus().toggleHeading({ level: 2 }).run()" 
        :class="{ 'is-active': editor.isActive('heading', { level: 2 }) }"
        class="toolbar-btn"
      >
        <i class="fas fa-heading"></i> H2
      </button>
      <button 
        type="button"
        @click="editor.chain().focus().toggleHeading({ level: 3 }).run()" 
        :class="{ 'is-active': editor.isActive('heading', { level: 3 }) }"
        class="toolbar-btn"
      >
        <i class="fas fa-heading"></i> H3
      </button>
      
      <span class="toolbar-divider"></span>
      
      <button 
        type="button"
        @click="editor.chain().focus().toggleBulletList().run()" 
        :class="{ 'is-active': editor.isActive('bulletList') }"
        class="toolbar-btn"
      >
        <i class="fas fa-list-ul"></i>
      </button>
      <button 
        type="button"
        @click="editor.chain().focus().toggleOrderedList().run()" 
        :class="{ 'is-active': editor.isActive('orderedList') }"
        class="toolbar-btn"
      >
        <i class="fas fa-list-ol"></i>
      </button>
      
      <span class="toolbar-divider"></span>
      
      <button 
        type="button"
        @click="editor.chain().focus().toggleBlockquote().run()" 
        :class="{ 'is-active': editor.isActive('blockquote') }"
        class="toolbar-btn"
      >
        <i class="fas fa-quote-right"></i>
      </button>
      <button 
        type="button"
        @click="editor.chain().focus().setHorizontalRule().run()" 
        class="toolbar-btn"
      >
        <i class="fas fa-minus"></i>
      </button>
      
      <span class="toolbar-divider"></span>
      
      <button 
        type="button"
        @click="setLink" 
        :class="{ 'is-active': editor.isActive('link') }"
        class="toolbar-btn"
      >
        <i class="fas fa-link"></i>
      </button>
      <button 
        type="button"
        @click="editor.chain().focus().unsetLink().run()" 
        :disabled="!editor.isActive('link')"
        class="toolbar-btn"
      >
        <i class="fas fa-unlink"></i>
      </button>
      
      <span class="toolbar-divider"></span>
      
      <button 
        type="button"
        @click="editor.chain().focus().undo().run()" 
        :disabled="!editor.can().undo()"
        class="toolbar-btn"
      >
        <i class="fas fa-undo"></i>
      </button>
      <button 
        type="button"
        @click="editor.chain().focus().redo().run()" 
        :disabled="!editor.can().redo()"
        class="toolbar-btn"
      >
        <i class="fas fa-redo"></i>
      </button>
    </div>
    
    <editor-content :editor="editor" class="editor-content" />
  </div>
</template>

<script lang="ts">
import { defineComponent, watch, onBeforeUnmount } from 'vue';
import { useEditor, EditorContent } from '@tiptap/vue-3';
import StarterKit from '@tiptap/starter-kit';
import Link from '@tiptap/extension-link';
import Placeholder from '@tiptap/extension-placeholder';

export default defineComponent({
  name: 'TiptapEditor',
  components: {
    EditorContent,
  },
  props: {
    modelValue: {
      type: String,
      default: '',
    },
    placeholder: {
      type: String,
      default: 'Write your content here...',
    },
  },
  emits: ['update:modelValue'],
  setup(props, { emit }) {
    const editor = useEditor({
      content: props.modelValue,
      extensions: [
        StarterKit,
        Link.configure({
          openOnClick: false,
          HTMLAttributes: {
            target: '_blank',
            rel: 'noopener noreferrer',
          },
        }),
        Placeholder.configure({
          placeholder: props.placeholder,
        }),
      ],
      onUpdate: ({ editor }) => {
        emit('update:modelValue', editor.getHTML());
      },
    });

    watch(() => props.modelValue, (value) => {
      const isSame = editor.value?.getHTML() === value;
      if (isSame) {
        return;
      }
      editor.value?.commands.setContent(value);
    });

    const setLink = () => {
      const previousUrl = editor.value?.getAttributes('link').href;
      const url = window.prompt('URL', previousUrl);

      if (url === null) {
        return;
      }

      if (url === '') {
        editor.value?.chain().focus().extendMarkRange('link').unsetLink().run();
        return;
      }

      editor.value?.chain().focus().extendMarkRange('link').setLink({ href: url }).run();
    };

    onBeforeUnmount(() => {
      editor.value?.destroy();
    });

    return {
      editor,
      setLink,
    };
  },
});
</script>

<style scoped>
.tiptap-editor {
  border: 1px solid #e2e8f0;
  border-radius: 8px;
  overflow: hidden;
  background: white;
}

.editor-toolbar {
  display: flex;
  flex-wrap: wrap;
  gap: 4px;
  padding: 8px;
  background: #f8fafc;
  border-bottom: 1px solid #e2e8f0;
}

.toolbar-btn {
  padding: 6px 10px;
  background: white;
  border: 1px solid #e2e8f0;
  border-radius: 4px;
  cursor: pointer;
  transition: all 0.2s;
  font-size: 14px;
  color: #475569;
}

.toolbar-btn:hover {
  background: #f1f5f9;
  border-color: #cbd5e1;
}

.toolbar-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.toolbar-btn.is-active {
  background: #d4a948;
  color: white;
  border-color: #d4a948;
}

.toolbar-divider {
  width: 1px;
  background: #e2e8f0;
  margin: 0 4px;
}

.editor-content {
  min-height: 400px;
}

.editor-content :deep(.ProseMirror) {
  padding: 1rem;
  outline: none;
  min-height: 400px;
}

.editor-content :deep(.ProseMirror p.is-editor-empty:first-child::before) {
  content: attr(data-placeholder);
  float: left;
  color: #adb5bd;
  pointer-events: none;
  height: 0;
}

.editor-content :deep(.ProseMirror h2) {
  font-size: 1.5rem;
  font-weight: 700;
  margin: 1.5rem 0 1rem;
}

.editor-content :deep(.ProseMirror h3) {
  font-size: 1.25rem;
  font-weight: 600;
  margin: 1.25rem 0 0.75rem;
}

.editor-content :deep(.ProseMirror p) {
  margin: 0.75rem 0;
}

.editor-content :deep(.ProseMirror ul),
.editor-content :deep(.ProseMirror ol) {
  padding-left: 1.5rem;
  margin: 0.75rem 0;
}

.editor-content :deep(.ProseMirror blockquote) {
  border-left: 3px solid #d4a948;
  padding-left: 1rem;
  margin: 1rem 0;
  font-style: italic;
  color: #64748b;
}

.editor-content :deep(.ProseMirror hr) {
  border: none;
  border-top: 2px solid #e2e8f0;
  margin: 1.5rem 0;
}

.editor-content :deep(.ProseMirror a) {
  color: #d4a948;
  text-decoration: underline;
}

.editor-content :deep(.ProseMirror strong) {
  font-weight: 600;
}

.editor-content :deep(.ProseMirror code) {
  background: #f1f5f9;
  padding: 2px 6px;
  border-radius: 4px;
  font-size: 0.9em;
}
</style>
