function value(name)
{
	var item = document.getElementById(name);
	return (item ? item.value : "");
}
function isset(name, val)
{
	return (value(name) == val);
}
function checked(name)
{
	var item = document.getElementById(name);
	return ((item) && item.checked);
}
function hide(name)
{
	var item = document.getElementById(name);
	if (item) 
		item.style.display = 'none';
}
function show(name)
{
	var item = document.getElementById(name);
	if (item)
		item.style.display = '';
}
function set_visible(name, value)
{
	if (value)
		show(name)
	else
		hide(name)
}
