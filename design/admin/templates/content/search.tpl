{* DO NOT EDIT THIS FILE! Use an override template instead. *}
{let search=false()}
{section show=$use_template_search}
    {set page_limit=10}
    {set search=fetch(content,search,
                      hash(text,$search_text,
                           section_id,$search_section_id,
                           subtree_array,$search_subtree_array,
                           sort_by,array('modified',false()),
                           offset,$view_parameters.offset,
                           limit,$page_limit))}
    {set search_result=$search['SearchResult']}
    {set search_count=$search['SearchCount']}
    {set stop_word_array=$search['StopWordArray']}
    {set search_data=$search}
{/section}

<form action={'/content/search/'|ezurl} method="get">

<div class="context-block">
<h2 class="context-title">{'Search'|i18n( 'design/admin/content/search' )}</h2>

<div class="context-attributes">

<div class="block">
    <input class="halfbox" type="text" name="SearchText" id="Search" value="{$search_text|wash}" />
    <input class="button"  name="SearchButton" type="submit" value="{'Search'|i18n( 'design/admin/content/search' )}" />
</div>

{section show=and(count($search_subtree_array)|eq(1),$search_subtree_array.0|ne(1))}
<div class="block">
<label><input type="radio" name="SubTreeArray" value="1" />{'All content'|i18n('design/admin/content/search')}</label>
<label><input type="radio" name="SubTreeArray" value="{$search_subtree_array.0}" checked="checked" />{'The same location'|i18n('design/admin/content/search')}</label>
</div>
{/section}

<div class="block">
    {let adv_url=concat( '/content/advancedsearch/', $search_text|count|gt( 0 )|choose('', concat( '?SearchText=', $search_text|urlencode ) ) )|ezurl}
    {'For more options try the %1Advanced search%2.'|i18n( 'design/admin/content/search', 'The parameters are link start and end tags.', array( concat( '<a href=', $adv_url, '>' ), '</a>' ) )}
    {/let}
</div>

{* Excluded words. *}
{section show=$stop_word_array}
<p>
{'The following words were excluded from the search:'|i18n( 'design/admin/content/search' )} 
{section name=StopWord loop=$stop_word_array}
    {$StopWord:item.word|wash}
    {delimiter}, {/delimiter}
{/section}
</p>
{/section}

{* No matches. *}
{section show=$search_count|not}
<h2>{'No results were found while searching for <%1>'|i18n( 'design/admin/content/search',, array( $search_text ) )|wash}</h2>
    <p>{'Search tips'|i18n( 'design/admin/content/search' )}</p>
    <ul>
        <li>{'Check spelling of keywords.'|i18n( 'design/admin/content/search' )}</li>
        <li>{'Try changing some keywords eg. car instead of cars.'|i18n( 'design/admin/content/search' )}</li>
        <li>{'Try more general keywords.'|i18n( 'design/admin/content/search' )}</li>
        <li>{'Fewer keywords gives more results, try reducing keywords until you get a result.'|i18n( 'design/admin/content/search' )}</li>
    </ul>
{/section}

</div>
</div>

{* Search result. *}
{section show=$search_count}
<div class="context-block">
<h2 class="context-title">{'Search for <%1> returned %2 matches'|i18n( 'design/admin/content/search',, array( $search_text, $search_count ) )|wash}</h2>
{include name=Result uri='design:content/searchresult.tpl' search_result=$search_result}

<div class="context-toolbar">
{include name=Navigator
         uri='design:navigator/google.tpl'
         page_uri='/content/search'
         page_uri_suffix=concat( '?SearchText=', $search_text|urlencode, $search_timestamp|gt( 0 )|choose( '', concat( '&SearchTimestamp=', $search_timestamp ) ) )
         item_count=$search_count
         view_parameters=$view_parameters
         item_limit=$page_limit}
</div>
</div>
{/section}



</form>
{/let}
