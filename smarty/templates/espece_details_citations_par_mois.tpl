<table>
<tr>
	<th></th>
	<th>J</th>
	<th>F</th>
	<th>M</th>
	<th>A</th>
	<th>M</th>
	<th>J</th>
	<th>J</th>
	<th>A</th>
	<th>S</th>
	<th>O</th>
	<th>N</th>
	<th>D</th>
</tr>
{foreach from=$liste item=t_annee key=annee}
	<tr>
		<th>{$annee}</th>
		<td width="8%" align="right"><div style="background-color:rgb({$t_annee.01.c},{$t_annee.01.c},255);">{$t_annee.01.n}</div></td>
		<td width="8%" align="right"><div style="background-color:rgb({$t_annee.02.c},{$t_annee.02.c},255);">{$t_annee.02.n}</div></td>
		<td width="8%" align="right"><div style="background-color:rgb({$t_annee.03.c},{$t_annee.03.c},255);">{$t_annee.03.n}</div></td>
		<td width="8%" align="right"><div style="background-color:rgb({$t_annee.04.c},{$t_annee.04.c},255);">{$t_annee.04.n}</div></td>
		<td width="8%" align="right"><div style="background-color:rgb({$t_annee.05.c},{$t_annee.05.c},255);">{$t_annee.05.n}</div></td>
		<td width="8%" align="right"><div style="background-color:rgb({$t_annee.06.c},{$t_annee.06.c},255);">{$t_annee.06.n}</div></td>
		<td width="8%" align="right"><div style="background-color:rgb({$t_annee.07.c},{$t_annee.07.c},255);">{$t_annee.07.n}</div></td>
		<td width="8%" align="right"><div style="background-color:rgb({$t_annee.08.c},{$t_annee.08.c},255);">{$t_annee.08.n}</div></td>
		<td width="8%" align="right"><div style="background-color:rgb({$t_annee.09.c},{$t_annee.09.c},255);">{$t_annee.09.n}</div></td>
		<td width="8%" align="right"><div style="background-color:rgb({$t_annee.10.c},{$t_annee.10.c},255);">{$t_annee.10.n}</div></td>
		<td width="8%" align="right"><div style="background-color:rgb({$t_annee.11.c},{$t_annee.11.c},255);">{$t_annee.11.n}</div></td>
		<td width="8%" align="right"><div style="background-color:rgb({$t_annee.12.c},{$t_annee.12.c},255);">{$t_annee.12.n}</div></td>
	</tr>
{/foreach}
</table>
