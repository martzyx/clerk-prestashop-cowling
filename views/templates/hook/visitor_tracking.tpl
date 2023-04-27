{*
*  @author Clerk.io
*  @copyright Copyright (c) 2017 Clerk.io
*
*  @license MIT License
*
*  Permission is hereby granted, free of charge, to any person obtaining a copy
*  of this software and associated documentation files (the "Software"), to deal
*  in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in all
* copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*}

<script type="text/javascript">

    {if ($clerk_collect_cart ==true && $isv17) }

        $(document).ajaxComplete(function(event,request, settings){
        //console.log('event: ',event ,' request: ', request, ' settings: ', settings);

        if( settings.data.includes("controller=cart") ){
            console.log('cart chages found');

            request = $.ajax({
                            type : "POST",  
                            url  : "{$link->getModuleLink('clerk', 'cart')}",  
                        });

                        request.done(function (response, textStatus, jqXHR){
                            console.log("Hooray, it worked!:",response);
                            var clerk_productids = response;
                            var clerk_last_productids = [];
                            if( localStorage.getItem('clerk_productids') !== null ){
                                clerk_last_productids = localStorage.getItem('clerk_productids').split(",");
                                clerk_last_productids = clerk_last_productids.map(Number);  
                            }
                            //sort
                            clerk_productids = clerk_productids.sort((a, b) => a - b);
                            clerk_last_productids = clerk_last_productids.sort((a, b) => a - b);
                            // compare
                            if(JSON.stringify(clerk_productids) == JSON.stringify(clerk_last_productids)){
                                // if equal - maybe compare content??
                                // console.log('equal: ', clerk_productids, clerk_last_productids)
                            }else{
                                // if not equal send cart to clerk
                                //console.log('not equal: ', clerk_productids, clerk_last_productids)
                                Clerk('cart', 'set', clerk_productids);
                            }
                            // save for next compare
                            localStorage.setItem("clerk_productids", clerk_productids);
                        });

                        request.fail(function (jqXHR, textStatus, errorThrown){  
                            console.error(
                                "The following error occurred: "+
                                textStatus, errorThrown
                            );
                        });
                }   
        });

    {/if}

    window.onload = function() {

        {if ($clerk_collect_cart == true) }

            {if ($clerk_cart_update == true && $isv17)} 

                request = $.ajax({
                            type : "POST",  
                            url  : "{$link->getModuleLink('clerk', 'cart')}",  
                        });

                request.done(function (response, textStatus, jqXHR){
                    var clerk_productids = response;
                    var clerk_last_productids = [];
                    if( localStorage.getItem('clerk_productids') !== null ){
                        clerk_last_productids = localStorage.getItem('clerk_productids').split(",");
                        clerk_last_productids = clerk_last_productids.map(Number);  
                    }
                    //sort
                    clerk_productids = clerk_productids.sort((a, b) => a - b);
                    clerk_last_productids = clerk_last_productids.sort((a, b) => a - b);
                    // compare
                    if(JSON.stringify(clerk_productids) == JSON.stringify(clerk_last_productids)){
                        // if equal - maybe compare content??
                        // console.log('equal: ', clerk_productids, clerk_last_productids)
                    }else{
                        // if not equal send cart to clerk
                        //console.log('not equal: ', clerk_productids, clerk_last_productids)
                            Clerk('cart', 'set', clerk_productids);
                    }
                    // save for next compare
                    localStorage.setItem("clerk_productids", clerk_productids);
                    });

                    request.fail(function (jqXHR, textStatus, errorThrown){  
                            console.error(
                                "The following error occurred: "+
                                textStatus, errorThrown
                            );
                    });

            {/if}

            {if (!$isv17) }
                    prestashop.on("updateCart", function (e) {
                        
                        request = $.ajax({
                            type : "POST",  
                            url  : "{$link->getModuleLink('clerk', 'cart')}",  
                        });

                        request.done(function (response, textStatus, jqXHR){
                            console.log("Hooray, it worked!:",response);
                            var clerk_productids = response;
                            var clerk_last_productids = [];
                            if( localStorage.getItem('clerk_productids') !== null ){
                                clerk_last_productids = localStorage.getItem('clerk_productids').split(",");
                                clerk_last_productids = clerk_last_productids.map(Number);  
                            }
                            //sort
                            clerk_productids = clerk_productids.sort((a, b) => a - b);
                            clerk_last_productids = clerk_last_productids.sort((a, b) => a - b);
                            // compare
                            if(JSON.stringify(clerk_productids) == JSON.stringify(clerk_last_productids)){
                                // if equal - maybe compare content??
                                // console.log('equal: ', clerk_productids, clerk_last_productids)
                            }else{
                                // if not equal send cart to clerk
                                //console.log('not equal: ', clerk_productids, clerk_last_productids)
                                Clerk('cart', 'set', clerk_productids);
                            }
                            // save for next compare
                            localStorage.setItem("clerk_productids", clerk_productids);
                        });

                        request.fail(function (jqXHR, textStatus, errorThrown){  
                            console.error(
                                "The following error occurred: "+
                                textStatus, errorThrown
                            );
                        });             
                    });

            {/if}

        {/if}
        
        {if ($powerstep_enabled && !$isv17)}

        //Handle powerstep
        prestashop.on("updateCart", function (e) {
            if (e.resp.success) {
                var product_id = e.resp.id_product;
                var product_id_attribute = e.resp.id_product_attribute;

                {if ($powerstep_type === 'page')}
                window.location.replace('{$link->getModuleLink('clerk', 'added')}' + "?id_product=" + encodeURIComponent(product_id));
                {else}

                $.ajax({
                    url: "{$link->getModuleLink('clerk', 'powerstep')}",
                    method: "POST",
                    data: {
                        id_product: product_id,
                        id_product_attribute: product_id_attribute,
                        popup: 1
                    },
                    success: function (res) {
                        var count = 0;
                        $(".modal-body").each(function () {
                            count = count+1;
                            if (count === 2) {
                                var modal = $(this);
                                modal.append(res)
                            }
                        });
                        Clerk("content",".clerk-powerstep-templates > span");

                    }
                });
                {/if}
            }
        });
        {/if}
    }
</script>
<!-- End of Clerk.io E-commerce Personalisation tool - www.clerk.io -->
{if ($exit_intent_enabled)}
    <style>
        .exit-intent {

            top: 10% !important;
            width: 80% !important;
            left: 5%;

        }
    </style>
{foreach $exit_intent_template as  $template}
    <span class="clerk exit-intent"
          data-template="@{$template}"
          data-exit-intent="true">
    </span>
{/foreach}
{/if}