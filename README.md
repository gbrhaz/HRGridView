# HRGridView

Container view that doesn't require subviews to be given frame values. Grids can be created
and split up into rows and columns.

Based off the WPF GridPanel control.

## How to use it?

- Each view that goes into the Grid container must have its row and column property set. This 
allows the container to set where the view will go.

- The Grid container itself must have the `columns` and `rows` array properties set.

- As with the WPF panel, row heights and column widths can be set in exact values, or they 
can be set with star (*) values. Currently the Auto value doesn't exist.

- Exact values are given priority first.  Star values then get the remaining space. It works as a 
ratio system. For example, if there are three columns, each with 2* values, they each get 1/3 of the 
space. However, if there are three columns, "* 2* *", the middle column will receive double the width 
as the other two columns.

## Is this Grid necessary?

Not in the slightest. I just sometimes find it easier to use than Auto Layout or "Springs and Struts". What's useful 
about this is that the Grid can be a subview itself, so it can be used only in certain parts of your app. For example, 
if you have a row of buttons and don't want to manually deal with sizes (assuming you're not just using interface builder), 
you can create a Grid container, give it 4 equal column widths, and put the buttons inside it. The rest will be sorted out by 
the view itself.