import tkinter as tk
def button_quit():
  os._exit(0)
root = tk.Tk()
tk.Button(root, text='quit', command=button_quit).pack()
root.mainloop()
