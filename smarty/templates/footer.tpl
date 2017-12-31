</div>
<div style="clear:both;"></div>
Exec : {$tps_exec_avant_display}
<script>
{literal}
function footer_init() {
	console.log('init lazy');
	J("img.lazy").lazyload();
}
J(footer_init);
{/literal}
</script>
</body>
</html>
