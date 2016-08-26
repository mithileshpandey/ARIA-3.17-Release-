/**********************************************************************
Name:  AriaAdminToolServiceResponseHandler
Copyright © 2013  Aria
============================================================================================================
Purpose:                                                           
-------  
This class have methods to parse the data from Aria response                        
============================================================================================================
History                                                           
-------                                                           
 AUTHOR                     DATE              DEVELOPER NAME                       
 - Simplion Technologies    04/30/2014        Rakesh Kedia & Mithilesh Panday & Dileep Singhal         
 
***********************************************************************/
public with sharing class AriaAdminToolServiceResponseHandler extends AriaAdminToolRequestResponse{
    // New Method introduce to reduce the characters or size of apex class
    // Checks for WDDXArray Elements
    private static boolean hasRecords(WDDXVariable var){
        boolean val = false;
        if(var!= null && var.item != WDDXNull.NIL){
                val = true;
        }
        return val; 
    } 
    private static Integer getIntVal(WDDXVariable var){
        Integer val = null;
        if(var!= null && var.item != WDDXNull.NIL){
                val = ((WDDXNumber)var.item).numValue.intValue();
        }
        return val;
    }
    private static Double getDoubVal(WDDXVariable var){
        Double val = null;
        if(var!= null && var.item != WDDXNull.NIL){
                val = ((WDDXNumber)var.item).numValue;
        }
        return val;
    }
    private static decimal getDeciVal(WDDXVariable var){
        decimal val = null;
        if(var!= null && var.item != WDDXNull.NIL){
                val = decimal.valueOf(((WDDXNumber)var.item).numValue);
        }
        return val;
    }
    private static long getLongVal(WDDXVariable var){
        long val = null;
        if(var!= null && var.item != WDDXNull.NIL){
                val = ((WDDXNumber)var.item).numValue.longValue();
        }
        return val;
    }
    private static String getStrVal(WDDXVariable var){
        String val = null;
        if(var!= null && var.item != WDDXNull.NIL){
                val = ((WDDXString)var.item).strValue;
        }
        if(val!=null){
            val.trim();
        }
        return val;
    }
    private static boolean getBoolVal(WDDXVariable var){
        boolean val = null;
        if(var!= null && var.item != WDDXNull.NIL){
                val = boolean.valueOf(((WDDXBoolean)var.item).boolValue);
        }
        return val;
    }
    static integer error_cd ;
    static string error_msg = ''; 
    private static void validateResponse(WDDXData data){
        error_cd = 0;
        error_msg = 'OK'; 
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        WDDXVariable errorCodeVar = mainStruct.get('error_code');
        error_cd = getIntVal(errorCodeVar);
        WDDXVariable errorMsgVar = mainStruct.get('error_msg');
        error_msg = getStrVal(errorMsgVar);
        if(error_msg == null){
            error_msg = 'Aria did not return an error message';
        }
    }
    //-- BenHur Admin tools api set
    // get_inventory_items
    
    public static get_inventory_items_Response handle_get_inventory_items(WDDXData data){
        get_inventory_items_Response response = new get_inventory_items_Response();
        
        validateResponse(data);
        response.error_code = error_cd;
        response.error_msg = error_msg;
        if(error_cd != 0) {
           return response;
        }
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        WDDXVariable inventory_items = mainStruct.get('inventory_items');
        if(hasRecords(inventory_items)){
            WDDXArray inventory_itemsArr = (WDDXArray)inventory_items.item;
            WDDXStruct inventory_itemStruct; 
            inventory_item inv_item;
            for(WDDXItem inventory_item_item : inventory_itemsArr.items) {
                inv_item = new inventory_item();
                inventory_itemStruct = (WDDXStruct)inventory_item_item;
                
                inv_item.item_no = getIntVal(inventory_itemStruct.get('item_no'));
                inv_item.item_name = getStrVal(inventory_itemStruct.get('item_name'));
                inv_item.item_type = getIntVal(inventory_itemStruct.get('item_type'));
                inv_item.client_sku = getStrVal(inventory_itemStruct.get('client_sku'));
                inv_item.active_ind = getIntVal(inventory_itemStruct.get('active_ind'));
                inv_item.client_item_id = getStrVal(inventory_itemStruct.get('client_item_id'));
                inv_item.stock_level = getDoubVal(inventory_itemStruct.get('stock_level'));
                            
                
                response.inventory_items.add(inv_item);
            }
        }
                
        return response;
    }
    //get_discount_rules
     public static get_discount_rules_Response handle_get_discount_rules(WDDXData data){
        get_discount_rules_Response response = new get_discount_rules_Response();
        
        validateResponse(data);
        response.error_code = error_cd;
        response.error_msg = error_msg;
        if(error_cd != 0) {
           return response;
        }
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        WDDXVariable discount_rules = mainStruct.get('discount_rules');
        if(hasRecords(discount_rules)){
            WDDXArray discount_rulesArr = (WDDXArray)discount_rules.item;
            WDDXStruct discount_ruleStruct; 
            discount_rule dis_rule;
            for(WDDXItem dis_rule_item : discount_rulesArr.items) {
                dis_rule = new discount_rule();
                discount_ruleStruct = (WDDXStruct)dis_rule_item;
                
                dis_rule.rule_no = getIntVal(discount_ruleStruct.get('rule_no'));
                dis_rule.rule_name = getStrVal(discount_ruleStruct.get('rule_name'));
                dis_rule.discount_type = getStrVal(discount_ruleStruct.get('rule_name'));
                dis_rule.rule_id = getStrVal(discount_ruleStruct.get('rule_id'));
                dis_rule.description = getStrVal(discount_ruleStruct.get('description'));
                dis_rule.ext_description = getStrVal(discount_ruleStruct.get('ext_description'));
                dis_rule.flat_percent_ind = getIntVal(discount_ruleStruct.get('flat_percent_ind'));
                dis_rule.amount = getDoubVal(discount_ruleStruct.get('amount'));
                dis_rule.rule_currency = getStrVal(discount_ruleStruct.get('currency'));
                            
                
                response.discount_rules.add(dis_rule);
            }
        }
                
        return response;
    }
    //handle_get_inventory_item_details
    
     public static get_inventory_item_details_Response handle_get_inventory_item_details(WDDXData data){
        get_inventory_item_details_Response response = new get_inventory_item_details_Response();
        
        validateResponse(data);
        response.error_code = error_cd;
        response.error_msg = error_msg;
        if(error_cd != 0) {
           return response;
        }
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        
        response.item_no = getIntVal(mainStruct.get('item_no'));
        response.client_item_id = getStrVal(mainStruct.get('client_item_id'));
        response.item_type = getIntVal(mainStruct.get('item_no'));
        
        response.item_name = getStrVal(mainStruct.get('item_name'));
        response.item_desc = getStrVal(mainStruct.get('item_desc'));
        response.active_ind = getIntVal(mainStruct.get('active_ind'));
        
        response.service_no = getIntVal(mainStruct.get('service_no'));
        response.client_service_id = getStrVal(mainStruct.get('client_service_id'));
        response.invoice_advancement_months = getIntVal(mainStruct.get('invoice_advancement_months'));
        
        response.plan_no = getIntVal(mainStruct.get('plan_no'));
        response.client_plan_id = getStrVal(mainStruct.get('client_plan_id'));
        response.client_sku = getStrVal(mainStruct.get('client_sku'));
        
        WDDXVariable pricings = mainStruct.get('pricing');
        if(hasRecords(pricings)){
            WDDXArray pricingsArr = (WDDXArray)pricings.item;
            WDDXStruct pricingsStruct; 
            pricing price;
            for(WDDXItem pricings_item : pricingsArr.items) {
                price = new pricing();
                pricingsStruct = (WDDXStruct)pricings_item;
                price.currency_cd = getStrVal(pricingsStruct.get('currency_cd'));
                price.item_price = getDoubVal(pricingsStruct.get('item_price'));
                price.price_per_unit = getDoubVal(pricingsStruct.get('price_per_unit'));
                response.pricings.add(price);
            }
        }
        response.modify_price_ind = getStrVal(mainStruct.get('modify_price_ind'));
        response.subunit_qty = getDoubVal(mainStruct.get('subunit_qty'));
        response.subunit_label = getStrVal(mainStruct.get('subunit_label'));
        response.days_to_expiry = getIntVal(mainStruct.get('days_to_expiry'));
        
        WDDXVariable resources = mainStruct.get('resources');
        if(hasRecords(resources)){
            WDDXArray resourcesArr = (WDDXArray)resources.item;
            WDDXStruct resourcesStruct; 
            resource res;
            for(WDDXItem resources_item : resourcesArr.items) {
                res = new resource();
                resourcesStruct = (WDDXStruct)resources_item;
                res.resource_type_no = getIntVal(resourcesStruct.get('resource_type_no'));
                res.resource_units = getIntVal(resourcesStruct.get('resource_units'));
                res.resource_name = getStrVal(resourcesStruct.get('resource_name'));
                response.resources.add(res);
            }
        }
        response.stock_level = getDoubVal(mainStruct.get('stock_level'));    
        // image parsing left
        WDDXVariable image = mainStruct.get('image');
        if(image != null && image.item != WDDXNull.NIL){
            if(image.item instanceof WDDXArray){
                WDDXArray imageArr = (WDDXArray)image.item;
                for(WDDXItem image_item : imageArr.items){
                    response.images.add(getImage((WDDXStruct)image_item));
                }
            }
            else if(image.item instanceof WDDXStruct){
                WDDXStruct image_struct = (WDDXStruct)image.item;
                integer counter = 1;
                while(true){
                    WDDXVariable tempVar = image_struct.get(''+counter);
                    if(tempVar == null){
                        break;
                    }
                    if(tempVar.item != WDDXNull.NIL){
                        response.images.add(getImage((WDDXStruct)tempVar.item));
                    }
                    counter++;
                }
            }
        }
        WDDXVariable supplemental_obj_fields = mainStruct.get('supplemental_obj_fields');
        if(hasRecords(supplemental_obj_fields)){
            WDDXArray supplemental_obj_fieldsArr = (WDDXArray)supplemental_obj_fields.item;
            for(WDDXItem supplemental_obj_fields_item : supplemental_obj_fieldsArr.items) {
                if(supplemental_obj_fields_item != WDDXNull.NIL){
                    response.supplemental_obj_fields.add(((WDDXString)supplemental_obj_fields_item).strValue);
                }
            }
        }   
        WDDXVariable item_class = mainStruct.get('item_class');
        if(hasRecords(item_class)){
            WDDXArray item_classArr = (WDDXArray)item_class.item;
            for(WDDXItem item_class_item : item_classArr.items) {
                if(item_class_item != WDDXNull.NIL){
                    response.item_class.add(((WDDXNumber)item_class_item).numValue.longValue());
                }
            }
        }    
        return response;
    }
    private static image getImage(WDDXStruct struct){
        image img = new image();
        img.thumbnail_image_url = getStrVal(struct.get('thumbnail_image_url'));
        img.image_text = getStrVal(struct.get('image_text'));
        img.default_ind = getIntVal(struct.get('default_ind'));
        img.image_class_seq_no = getIntVal(struct.get('image_class_seq_no'));
        img.active = getIntVal(struct.get('active')); 
        img.main_image_url = getStrVal(struct.get('main_image_url'));
        return img;
    }
    // response handler for get chart of account entry
    public static get_coa_response handle_get_coa(WDDXData data){
        get_coa_response response = new get_coa_response();             
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        validateResponse(data);
        response.error_code = error_cd;
        response.error_msg = error_msg;
        if(error_cd != 0) {
           return response;
        }
        WDDXVariable coaVar = mainStruct.get('coa');
        WDDXStruct coaStruct = (WDDXStruct)coaVar.item;
        coa obj_coa = new coa();
        //find coa_id
        obj_coa.coa_id = getLongVal(coaStruct.get('coa_id'));
        //find coa_code
        obj_coa.coa_code = getStrVal( coaStruct.get('coa_code'));
        //find coa_description
        obj_coa.coa_description = getStrVal(coaStruct.get('coa_description'));
        response.coa_entry.add(obj_coa);
        return response;
    }
    
    // response handler for get company profile
    public static get_company_profile_response handle_get_company_profile(WDDXData data){
        get_company_profile_response response = new get_company_profile_response();             
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        validateResponse(data);
        response.error_code = error_cd;
        response.error_msg = error_msg;
        if(error_cd != 0) {
           return response; 
        } 
        WDDXVariable compProfileVar = mainStruct.get('client');
        WDDXStruct compProfileStruct = (WDDXStruct)compProfileVar.item;
        client obj_client = new client();
        obj_client.client_name = getStrVal( compProfileStruct.get('client_name'));
        obj_client.domain = getStrVal( compProfileStruct.get('domain'));
        obj_client.address1 = getStrVal( compProfileStruct.get('address1'));    
        obj_client.address2 = getStrVal( compProfileStruct.get('address2'));    
        obj_client.city = getStrVal( compProfileStruct.get('city'));
        obj_client.locality = getStrVal( compProfileStruct.get('locality'));
        obj_client.state_prov = getStrVal( compProfileStruct.get('state_prov'));
        obj_client.country = getStrVal( compProfileStruct.get('country'));
        obj_client.postal_code = getStrVal( compProfileStruct.get('postal_code'));  
        obj_client.phone = getStrVal( compProfileStruct.get('phone'));
        obj_client.contact = getStrVal( compProfileStruct.get('contact'));
        obj_client.contact_address1 = getStrVal( compProfileStruct.get('contact_address1'));
        obj_client.contact_address2 = getStrVal( compProfileStruct.get('contact_address2'));    
        obj_client.contact_city = getStrVal( compProfileStruct.get('contact_city'));
        obj_client.contact_state = getStrVal( compProfileStruct.get('contact_state'));
        obj_client.contact_zip = getStrVal( compProfileStruct.get('contact_zip'));
        obj_client.contact_phone = getStrVal( compProfileStruct.get('contact_phone'));  
        obj_client.contact_email = getStrVal( compProfileStruct.get('contact_email'));  
        obj_client.billing_contact = getStrVal( compProfileStruct.get('billing_contact'));  
        obj_client.billing_address1 = getStrVal( compProfileStruct.get('billing_address1'));    
        obj_client.billing_address2 = getStrVal( compProfileStruct.get('billing_address2'));    
        obj_client.billing_city = getStrVal( compProfileStruct.get('billing_city'));    
        obj_client.billing_state = getStrVal( compProfileStruct.get('billing_state'));  
        obj_client.billing_zip = getStrVal( compProfileStruct.get('billing_zip'));  
        obj_client.billing_phone = getStrVal( compProfileStruct.get('billing_phone'));  
        obj_client.billing_email = getStrVal( compProfileStruct.get('billing_email'));  
        obj_client.contact_country = getStrVal( compProfileStruct.get('contact_country'));  
        obj_client.contact_locality = getStrVal( compProfileStruct.get('contact_locality'));    
        obj_client.billing_country = getStrVal( compProfileStruct.get('billing_country'));  
        obj_client.billing_locality = getStrVal( compProfileStruct.get('billing_locality'));
        response.clients.add(obj_client);
        return response;
    }
    
    // response handler for get company profile
    public static get_coupon_details_response handle_get_coupon_details(WDDXData data){
        get_coupon_details_response response = new get_coupon_details_response();             
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        validateResponse(data);
        response.error_code = error_cd;
        response.error_msg = error_msg;
        if(error_cd != 0) {
           return response; 
        } 
        response.coupon_cd = getStrVal( mainStruct.get('coupon_cd'));
        response.coupon_desc = getStrVal( mainStruct.get('coupon_desc'));
        response.coupon_msg = getStrVal( mainStruct.get('coupon_msg'));
        response.status_ind = getIntVal( mainStruct.get('status_ind'));
        response.no_of_uses = getIntVal( mainStruct.get('no_of_uses'));
        response.start_date = getStrVal( mainStruct.get('start_date'));
        response.end_date = getStrVal( mainStruct.get('end_date'));
        WDDXVariable cred_temp_var = mainStruct.get('credit_template');
        if(hasRecords(cred_temp_var)){
            WDDXArray cred_temp_arr = (WDDXArray)cred_temp_var.item;
            credit_template cr_tmp;
            for(WDDXItem item : cred_temp_arr.items) {
                cr_tmp = new credit_template();
                WDDXStruct cr_tmp_strct = (WDDXStruct)item;
                cr_tmp.credit_template_no = getIntVal(cr_tmp_strct.get('credit_template_no'));
                cr_tmp.credit_template_name = getStrVal(cr_tmp_strct.get('credit_template_name'));
                cr_tmp.client_credit_template_id = getStrVal(cr_tmp_strct.get('client_credit_template_id'));
                cr_tmp.eligible_plan_no = getIntVal(cr_tmp_strct.get('eligible_plan_no'));
                try{
                    cr_tmp.eligible_client_plan_id = getStrVal(cr_tmp_strct.get('eligible_client_plan_id'));
                }catch(Exception ex){}
                try{
                    cr_tmp.eligible_service_no = getIntVal(cr_tmp_strct.get('eligible_service_no'));
                }catch(Exception ex){}
                try{
                    cr_tmp.eligible_client_service_id = getIntVal(cr_tmp_strct.get('eligible_client_service_id'));
                }catch(Exception ex){}
                cr_tmp.no_of_credits = getIntVal(cr_tmp_strct.get('no_of_credits'));
                cr_tmp.time_between_credits = getIntVal(cr_tmp_strct.get('time_between_credits'));
                cr_tmp.discount_type = getIntVal(cr_tmp_strct.get('discount_type'));
                cr_tmp.discount_amt = getDoubVal(cr_tmp_strct.get('discount_amt'));         
                cr_tmp.percentage_plan_no = getIntVal(cr_tmp_strct.get('percentage_plan_no'));
                cr_tmp.percentage_client_plan_id = getStrVal(cr_tmp_strct.get('percentage_client_plan_id'));
                cr_tmp.percentage_service_no = getlongVal(cr_tmp_strct.get('percentage_service_no'));
                try{
                    cr_tmp.percentage_client_service_id = getlongVal(cr_tmp_strct.get('percentage_client_service_id'));
                }catch(Exception ex){}
                cr_tmp.alt_service_no = getIntVal(cr_tmp_strct.get('alt_service_no'));
                try{
                    cr_tmp.alt_client_service_id = getStrVal(cr_tmp_strct.get('alt_client_service_id'));
                }catch(Exception ex){}
                WDDXVariable el_src_typ_var = cr_tmp_strct.get('eligible_service_types');
                if(el_src_typ_var != null){
                    WDDXArray el_src_typ_arr = (WDDXArray)el_src_typ_var.item;
                    for(WDDXItem itm :  el_src_typ_arr.items){
                        cr_tmp.eligible_service_types.add(((WDDXString)itm).strValue);
                    }
                }
                response.credit_templates.add(cr_tmp);
            }
        }
        
        WDDXVariable dcnt_rule_var = mainStruct.get('discount_rule');
        if(hasRecords(dcnt_rule_var)){
            WDDXArray dcnt_rule_arr = (WDDXArray)dcnt_rule_var.item;
            discount_rule_for_coupon dcnt_rul;
            for(WDDXItem item : dcnt_rule_arr.items) {
                dcnt_rul = new discount_rule_for_coupon();
                WDDXStruct dcnt_rul_strct = (WDDXStruct)item;
                dcnt_rul.rule_no = getIntVal(dcnt_rul_strct.get('rule_no'));
                dcnt_rul.rule_id = getStrVal(dcnt_rul_strct.get('rule_id'));
                dcnt_rul.description = getStrVal(dcnt_rul_strct.get('description'));
                dcnt_rul.ext_description = getStrVal(dcnt_rul_strct.get('ext_description'));
                dcnt_rul.flat_percent_ind = getIntVal(dcnt_rul_strct.get('flat_percent_ind'));
                dcnt_rul.max_applicable_months = getIntVal(dcnt_rul_strct.get('max_applicable_months'));
                dcnt_rul.max_applications_per_acct = getIntVal(dcnt_rul_strct.get('max_applications_per_acct'));
                dcnt_rul.service_code_to_use = getIntVal(dcnt_rul_strct.get('service_code_to_use'));
                try{
                    dcnt_rul.alt_service_no_2_apply = getIntVal(dcnt_rul_strct.get('alt_service_no_2_apply'));
                }catch(Exception ex){}
                try{
                    dcnt_rul.alt_service_id_2_apply = getIntVal(dcnt_rul_strct.get('alt_service_id_2_apply'));
                }catch(Exception ex){}
                dcnt_rul.scope_no = getIntVal(dcnt_rul_strct.get('scope_no'));
                dcnt_rul.currency1 = getStrVal(dcnt_rul_strct.get('currency'));
                dcnt_rul.duration_type_ind = getStrVal(dcnt_rul_strct.get('duration_type_ind'));
                dcnt_rul.inline_offset_ind = getStrVal(dcnt_rul_strct.get('inline_offset_ind'));
                dcnt_rul.amount = getDeciVal(dcnt_rul_strct.get('amount'));
                
                WDDXVariable plan_no_var = dcnt_rul_strct.get('plan_no');
                if(plan_no_var != null){
                    WDDXArray plan_no_arr = (WDDXArray)plan_no_var.item;
                    for(WDDXItem itm :  plan_no_arr.items){
                        dcnt_rul.plan_nos.add(((WDDXNumber)itm).numValue.intValue());
                    }
                }
                
                WDDXVariable client_plan_id_var = dcnt_rul_strct.get('client_plan_id');
                if(client_plan_id_var != null){
                    WDDXArray client_plan_id_arr = (WDDXArray)client_plan_id_var.item;
                    for(WDDXItem itm :  client_plan_id_arr.items){
                        dcnt_rul.client_plan_ids.add(((WDDXString)itm).strValue);
                    }
                }
                
                WDDXVariable service_no_var = dcnt_rul_strct.get('service_no');
                if(service_no_var != null){
                    WDDXArray service_no_arr = (WDDXArray)service_no_var.item;
                    for(WDDXItem itm :  service_no_arr.items){
                        dcnt_rul.service_nos.add(((WDDXNumber)itm).numValue.intValue());
                    }
                }
                
                WDDXVariable client_service_id_var = dcnt_rul_strct.get('client_service_id');
                if(client_service_id_var != null){
                    WDDXArray client_service_id_arr = (WDDXArray)client_service_id_var.item;
                    for(WDDXItem itm :  client_service_id_arr.items){
                        dcnt_rul.client_service_ids.add(((WDDXNumber)itm).numValue.intValue());
                    }
                }
                
                WDDXVariable item_no_var = dcnt_rul_strct.get('item_no');
                if(item_no_var != null){
                    WDDXArray item_no_arr = (WDDXArray)item_no_var.item;
                    for(WDDXItem itm :  item_no_arr.items){
                        dcnt_rul.item_nos.add(((WDDXNumber)itm).numValue.intValue());
                     }
                }
                
                WDDXVariable client_item_id_var = dcnt_rul_strct.get('client_item_id');
                if(client_item_id_var != null){
                    WDDXArray client_item_id_arr = (WDDXArray)client_item_id_var.item;
                    for(WDDXItem itm :  client_item_id_arr.items){
                        dcnt_rul.client_item_ids.add(((WDDXNumber)itm).numValue.intValue());
                    }
                }
                
                response.discount_rules.add(dcnt_rul);
                
            }
        }
        
        WDDXVariable dis_bun_var = mainStruct.get('discount_bundle');
        if(!hasRecords(dis_bun_var)){
            return response; 
        }
        
        WDDXArray disc_bndl_arr = (WDDXArray)dis_bun_var.item;
        discount_bundle bundle;
        for(WDDXItem itm :disc_bndl_arr.items){
            bundle = new discount_bundle();
            WDDXStruct dis_bndl_strct = (WDDXStruct)itm;
            bundle.bundle_no = getIntVal(dis_bndl_strct.get('bundle_no'));
            bundle.bundle_name = getStrVal(dis_bndl_strct.get('bundle_name'));
            bundle.bundle_id = getStrVal(dis_bndl_strct.get('bundle_id'));
            bundle.description = getStrVal(dis_bndl_strct.get('description'));
            
            WDDXVariable rule_var = dis_bndl_strct.get('rules');
            if(rule_var != null){
                WDDXArray rule_arr = (WDDXArray)rule_var.item;
                for(WDDXItem r_itm :    rule_arr.items){
                    bundle.rules.add(((WDDXNumber)r_itm).numValue.intValue());
                }
            }
            
            WDDXVariable rule_ids_var = dis_bndl_strct.get('rule_ids');
            if(rule_ids_var != null){
                WDDXArray rule_ids_arr = (WDDXArray)rule_ids_var.item;
                for(WDDXItem r_itm1 :   rule_ids_arr.items){
                    bundle.rule_ids.add(((WDDXString)r_itm1).strValue);
                }
            }
            
            response.discount_bundles.add(bundle);
        }
        
        return response;
    }
   
  
    
    // response handler for handle_get_coupons
    public static get_coupons_response handle_get_coupons(WDDXData data){
        get_coupons_response response = new get_coupons_response();             
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        validateResponse(data);
        response.error_code = error_cd;
        response.error_msg = error_msg;
        if(error_cd != 0) {
           return response; 
        } 
        WDDXVariable coupServicesVar = mainStruct.get('coupons');
        if(!hasRecords(coupServicesVar)){
            return response; 
        }
        services obj_services;
        WDDXStruct coupServicesStruct;
        WDDXArray coupServicesArr = (WDDXArray)coupServicesVar.item;
        for(WDDXItem coupServicesItem : coupServicesArr.items) {
            obj_services = new services();
            coupServicesStruct = (WDDXStruct)coupServicesItem;
            //find coupon_cd
            obj_services.coupon_cd = getStrVal(coupServicesStruct.get('coupon_cd'));
            //find coupon_desc
            obj_services.coupon_desc = getStrVal(coupServicesStruct.get('coupon_desc'));
            //find expires_desc
            obj_services.expires_after = getStrVal(coupServicesStruct.get('expires_after'));
            response.services.add(obj_services);
        }
        return response;
    }
    
     // response handler for get_discount_bundle_details
    public static get_discount_bundle_details_response handle_get_discount_bundle_details(WDDXData data){
        get_discount_bundle_details_response res = new get_discount_bundle_details_response();             
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        validateResponse(data);
        res.error_code = error_cd;
        res.error_msg = error_msg;
        if(error_cd != 0) {
           return res; 
        } 
        WDDXVariable discount_bundlesVar = mainStruct.get('discount_bundles');
        if(!hasRecords(discount_bundlesVar)){
            return res; 
        }
        WDDXArray disc_bndl_arr = (WDDXArray)discount_bundlesVar.item;
        if(disc_bndl_arr.items.size()== 0){
            return res; 
        }
        
        WDDXStruct dis_bndl_strct = (WDDXStruct) disc_bndl_arr.items[0];
        res.bundle_no = getLongVal(dis_bndl_strct.get('bundle_no'));
        res.bundle_name = getStrVal(dis_bndl_strct.get('bundle_name'));
        system.debug('==========dis_bndl_strct========================='+dis_bndl_strct);
        res.bundle_id = getStrVal(dis_bndl_strct.get('bundle_id'));
        res.description = getStrVal(dis_bndl_strct.get('description'));
        res.allow_overlap_ind = getStrVal(dis_bndl_strct.get('allow_overlap_ind'));
        if(dis_bndl_strct.get('rules') != null){
            WDDXVariable rules_var = dis_bndl_strct.get('rules');
            WDDXArray rules_arr = (WDDXArray)rules_var.item;
            for(WDDXItem itm :  rules_arr.items){
                res.rules.add(((WDDXNumber)itm).numValue.longValue());
            }
        }
        if(dis_bndl_strct.get('rule_ids') != null){
            WDDXVariable rule_ids_var = dis_bndl_strct.get('rule_ids');
            WDDXArray rule_ids_arr = (WDDXArray)rule_ids_var.item;
            for(WDDXItem itm :  rule_ids_arr.items){
                res.rule_ids.add(((WDDXString)itm).strValue);
            }
        }
        return res;
    }
    
    // response handler for get_discount_bundles
    public static get_discount_bundles_response handle_get_discount_bundles(WDDXData data){
        get_discount_bundles_response res = new get_discount_bundles_response();             
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        validateResponse(data);
        res.error_code = error_cd;
        res.error_msg = error_msg;
        if(error_cd != 0) {
           return res; 
        } 
        WDDXVariable discount_bundlesVar = mainStruct.get('discount_bundles');
        if(!hasRecords(discount_bundlesVar)){
            return res; 
        }
        WDDXArray disc_bndl_arr = (WDDXArray)discount_bundlesVar.item;
        WDDXStruct dis_bndl_strct ;
        discount_bundle bundle;
        for(WDDXItem itm :disc_bndl_arr.items){
            bundle = new discount_bundle();
            dis_bndl_strct = (WDDXStruct)itm;
            bundle.bundle_no = getIntVal(dis_bndl_strct.get('bundle_no'));
            bundle.bundle_name = getStrVal(dis_bndl_strct.get('bundle_name'));
            bundle.bundle_id = getStrVal(dis_bndl_strct.get('bundle_id'));
            bundle.description = getStrVal(dis_bndl_strct.get('description'));
            res.discount_bundles.add(bundle);
        }
        
        return res;
    }
    
    // response handler for get_discount_rule_details_response
    public static get_discount_rule_details_response handle_get_discount_rule_details(WDDXData data){
        get_discount_rule_details_response res = new get_discount_rule_details_response();             
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        validateResponse(data);
        res.error_code = error_cd;
        res.error_msg = error_msg;
        if(error_cd != 0) {
           return res; 
        } 
        WDDXVariable dis_rul_Var = mainStruct.get('discount_rules');
        if(!hasRecords(dis_rul_Var)){
            return res; 
        }
        WDDXArray dis_rul_arr = (WDDXArray)dis_rul_Var.item;
        if(dis_rul_arr.items == null || dis_rul_arr.items.size() == 0){
            return res; 
        }
        
        WDDXStruct dis_rule_strct = (WDDXStruct)dis_rul_arr.items[0];
        res.rule_no =  getLongVal(dis_rule_strct.get('rule_no'));
        res.rule_id =  getStrVal(dis_rule_strct.get('rule_id'));
        res.description =  getStrVal(dis_rule_strct.get('description'));
        res.ext_description =  getStrVal(dis_rule_strct.get('ext_description'));
        res.flat_percent_ind =  getIntVal(dis_rule_strct.get('flat_percent_ind'));
        res.amount =  getDeciVal(dis_rule_strct.get('amount'));
        res.currency1 =  getStrVal(dis_rule_strct.get('currency'));
        res.duration_type_ind =  getStrVal(dis_rule_strct.get('duration_type_ind'));
        res.max_applicable_months =  getIntVal(dis_rule_strct.get('max_applicable_months'));
        res.max_applications_per_acct =  getIntVal(dis_rule_strct.get('max_applications_per_acct'));
        res.inline_offset_ind =  getStrVal(dis_rule_strct.get('inline_offset_ind'));
        res.service_code_to_use =  getIntVal(dis_rule_strct.get('service_code_to_use'));
        res.alt_service_no_2_apply =  getIntVal(dis_rule_strct.get('alt_service_no_2_apply'));
        res.alt_service_id_2_apply =  getStrVal(dis_rule_strct.get('alt_service_id_2_apply'));
        res.scope_no =  getIntVal(dis_rule_strct.get('scope_no'));
        if(dis_rule_strct.get('plan_no')!=null){
            WDDXVariable plan_no_var = dis_rule_strct.get('plan_no');
            if(plan_no_var != null){
                WDDXArray plan_no_arr = (WDDXArray)plan_no_var.item;
                for(WDDXItem itm :  plan_no_arr.items){
                    res.plan_no.add(((WDDXNumber)itm).numValue.longValue());
                }
            }
        }
        if(dis_rule_strct.get('client_plan_id')!=null){
            WDDXVariable client_plan_id_var = dis_rule_strct.get('client_plan_id');
            if(client_plan_id_var != null){
                WDDXArray client_plan_id_arr = (WDDXArray)client_plan_id_var.item;
                for(WDDXItem itm :  client_plan_id_arr.items){
                    res.client_plan_id.add(((WDDXString)itm).strValue);
                }
            }
        }
        if(dis_rule_strct.get('service_no')!=null){
            WDDXVariable service_no_var = dis_rule_strct.get('service_no');
            if(service_no_var != null){
                WDDXArray service_no_arr1 = (WDDXArray)service_no_var.item;
                WDDXArray service_no_arr = (WDDXArray)service_no_arr1.items[0];
                for(WDDXItem itm :  service_no_arr.items){
                    res.service_no.add(((WDDXNumber)itm).numValue.intValue());
                }
            }
        }
        
        if(dis_rule_strct.get('client_service_id')!=null){
            WDDXVariable client_service_id_var = dis_rule_strct.get('client_service_id');
            if(client_service_id_var != null){
                WDDXArray client_service_id_arr1 = (WDDXArray)client_service_id_var.item;
                WDDXArray client_service_id_arr = (WDDXArray)client_service_id_arr1.items[0];
                for(WDDXItem itm :  client_service_id_arr.items){
                    res.client_service_id.add(((WDDXString)itm).strValue);
                }
            }
        }
        if(dis_rule_strct.get('item_no')!=null){
            WDDXVariable item_no_var = dis_rule_strct.get('item_no');
            if(item_no_var != null){
                WDDXArray item_no_arr1 = (WDDXArray)item_no_var.item;
                WDDXArray item_no_arr = (WDDXArray)item_no_arr1.items[0];
                for(WDDXItem itm :  item_no_arr.items){
                    res.item_no.add(((WDDXNumber)itm).numValue.intValue());
                 }
            }
        }
        if(dis_rule_strct.get('client_item_id')!=null){  
            WDDXVariable client_item_id_var = dis_rule_strct.get('client_item_id');
            if(client_item_id_var != null){
                WDDXArray client_item_id_arr1 = (WDDXArray)client_item_id_var.item;
                WDDXArray client_item_id_arr = (WDDXArray)client_item_id_arr1.items[0];
                for(WDDXItem itm :  client_item_id_arr.items){
                    res.client_item_id.add(((WDDXNumber)itm).numValue.intValue());
                }
            }
        }
       return res;
    }
    
    
    //Rakesh-- response handler for get_plan_details---  Test--- 10000225 and 11149518
    public static get_plan_details_response handle_get_plan_details(WDDXData data){
        get_plan_details_response res = new get_plan_details_response();             
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        validateResponse(data);
        res.error_code = error_cd;
        res.error_msg = error_msg;
        if(error_cd != 0) {
           return res; 
        } 
         
        res.plan_no =  getStrVal(mainStruct.get('plan_no'));
        res.client_plan_id =  getStrVal(mainStruct.get('client_plan_id'));
        res.plan_name =  getStrVal(mainStruct.get('plan_name'));
        res.plan_level =  getIntVal(mainStruct.get('plan_level'));
        res.plan_type =  getStrVal(mainStruct.get('plan_type'));
        res.plan_description =  getStrVal(mainStruct.get('plan_description'));
        
        if(mainStruct.get('plan_groups') != null){
            WDDXVariable plan_groups_var = mainStruct.get('plan_groups');
            WDDXArray plan_groups_arr = (WDDXArray)plan_groups_var.item;
            WDDXStruct plan_groups_strct;
            for(WDDXItem itm :  plan_groups_arr.items){
                plan_groups_strct = (WDDXStruct)itm;
                res.plan_groups.add(getIntVal(plan_groups_strct.get('plan_group')));
                
            }
        }
        if(mainStruct.get('plan_group_ids') != null){
            WDDXVariable plan_group_ids_var = mainStruct.get('plan_group_ids');
            WDDXArray plan_group_ids_arr = (WDDXArray)plan_group_ids_var.item;
            WDDXStruct plan_group_ids_strct;
            for(WDDXItem itm :  plan_group_ids_arr.items){
                plan_group_ids_strct = (WDDXStruct)itm;
                res.plan_group_ids.add(getStrVal(plan_group_ids_strct.get('plan_group_id'))); 
            }
        } 
        res.currency_cd =  getStrVal(mainStruct.get('currency_cd')); 
        res.billing_interval =  getIntVal(mainStruct.get('billing_interval'));
        res.usage_billing_interval =  getStrVal(mainStruct.get('usage_billing_interval'));
        res.active_ind =  getIntVal(mainStruct.get('active_ind'));
        res.rollover_months =  getStrVal(mainStruct.get('rollover_months'));
        res.rollover_plan_no =  getIntVal(mainStruct.get('rollover_plan_no'));
        res.rollover_client_plan_id =  getStrVal(mainStruct.get('rollover_client_plan_id'));
        res.allow_child_accounts =  getStrVal(mainStruct.get('allow_child_accounts'));
        res.dunning_plan_no =  getIntVal(mainStruct.get('dunning_plan_no'));
        res.dunning_client_plan_id =  getStrVal(mainStruct.get('dunning_client_plan_id'));
        res.free_trial_type =  getIntVal(mainStruct.get('free_trial_type'));
        res.free_trial_duration =  getIntVal(mainStruct.get('free_trial_duration'));
        res.initial_free_months =  getIntVal(mainStruct.get('initial_free_months'));
        res.acct_status_cd =  getStrVal(mainStruct.get('acct_status_cd')); 
        res.rollover_acct_status_days =  getIntVal(mainStruct.get('rollover_acct_status_days'));
        res.rollover_acct_status_cd =  getStrVal(mainStruct.get('rollover_acct_status_cd'));
        res.template_no =  getIntVal(mainStruct.get('template_no')); 
        res.template_id =  getIntVal(mainStruct.get('template_id'));
        res.plan_cancel_min_months =  getIntVal(mainStruct.get('plan_cancel_min_months')); 
        res.how_to_apply_min_fee =  getStrVal(mainStruct.get('how_to_apply_min_fee'));
        res.is_deletable =  getStrVal(mainStruct.get('is_deletable'));
        
        if(mainStruct.get('services') != null){
            WDDXVariable services_var = mainStruct.get('services');
            WDDXArray services_arr = (WDDXArray)services_var.item;
            WDDXStruct service_strct;
            service obj_services;
            for(WDDXItem itm :  services_arr.items){
                obj_services = new service();
                service_strct = (WDDXStruct)itm;
                obj_services.service_no = getIntVal(service_strct.get('service_no'));
                obj_services.client_service_id = getStrVal(service_strct.get('client_service_id'));
                res.services.add(obj_services); 
            }
        }
        if(mainStruct.get('resources') != null){
            WDDXVariable resources_var = mainStruct.get('resources');
            WDDXArray resources_arr = (WDDXArray)resources_var.item;
            WDDXStruct resources_strct;
            for(WDDXItem itm :  resources_arr.items){
                resources_strct = (WDDXStruct)itm;
                res.resources.add(getIntVal(resources_strct.get('resources'))); 
            }
        } 
        
        if(mainStruct.get('parent_plans') != null){
            WDDXVariable parent_plans_var = mainStruct.get('parent_plans');
            WDDXArray parent_plans_arr = (WDDXArray)parent_plans_var.item;
            WDDXStruct parent_plans_strct;
            for(WDDXItem itm :  parent_plans_arr.items){
                parent_plans_strct = (WDDXStruct)itm;
                res.parent_plans.add(getIntVal(parent_plans_strct.get('parent_plans'))); 
            }
        } 
        
        if(mainStruct.get('parent_plan_ids') != null){
            WDDXVariable parent_plan_ids_var = mainStruct.get('parent_plan_ids');
            WDDXArray parent_plan_ids_arr = (WDDXArray)parent_plan_ids_var.item;
            WDDXStruct parent_plan_ids_strct;
            for(WDDXItem itm :  parent_plan_ids_arr.items){
                parent_plan_ids_strct = (WDDXStruct)itm;
                res.parent_plan_ids.add(getIntVal(parent_plan_ids_strct.get('parent_plan_ids'))); 
            }
        } 
        
        if(mainStruct.get('exclusion_plans') != null){
            WDDXVariable exclusion_plans_var = mainStruct.get('exclusion_plans');
            WDDXArray exclusion_plans_arr = (WDDXArray)exclusion_plans_var.item;
            WDDXStruct exclusion_plans_strct;
            for(WDDXItem itm :  exclusion_plans_arr.items){
                exclusion_plans_strct = (WDDXStruct)itm;
                res.exclusion_plans.add(getIntVal(exclusion_plans_strct.get('exclusion_plans'))); 
            }
        }
         
        if(mainStruct.get('supplemental_obj_fields') != null){
            WDDXVariable supplemental_obj_fields_var = mainStruct.get('supplemental_obj_fields');
            WDDXArray supplemental_obj_fields_arr = (WDDXArray)supplemental_obj_fields_var.item;
            WDDXStruct supplemental_obj_fields_strct;
            for(WDDXItem itm :  supplemental_obj_fields_arr.items){
                supplemental_obj_fields_strct = (WDDXStruct)itm;
                res.supplemental_obj_fields.add(getStrVal(supplemental_obj_fields_strct.get('supplemental_obj_fields'))); 
            }
        } 
       return res;
    }
    
    //Rakesh-- response handler for get_plan_group_details ---  Test--- group no : 2
    public static get_plan_group_details_response handle_get_plan_group_details(WDDXData data){
        get_plan_group_details_response res = new get_plan_group_details_response();             
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        validateResponse(data);
        res.error_code = error_cd;
        res.error_msg = error_msg;
        if(error_cd != 0) {
           return res; 
        } 
            
        res.group_no =  getIntVal(mainStruct.get('group_no'));
        res.group_name =  getStrVal(mainStruct.get('group_name'));
        res.group_desc =  getStrVal(mainStruct.get('group_desc'));
        res.client_plan_change_group_id =  getStrVal(mainStruct.get('client_plan_change_group_id'));
        res.group_usage =  getStrVal(mainStruct.get('group_usage'));
        
        if(mainStruct.get('plans') != null){
            WDDXVariable plans_var = mainStruct.get('plans');
            WDDXArray plans_arr = (WDDXArray)plans_var.item;
            WDDXStruct plans_strct;
            plan obj_plans;
            for(WDDXItem itm :  plans_arr.items){
                obj_plans = new plan();
                plans_strct = (WDDXStruct)itm;
                obj_plans.plan_name = getStrVal(plans_strct.get('plan_name'));
                obj_plans.plan_desc = getStrVal(plans_strct.get('plan_desc'));
                res.plans.add(obj_plans);   
            }
        }
        return res;
    }
    
    //Rakesh-- response handler for get_plan_groups
    public static get_plan_groups_response handle_get_plan_groups(WDDXData data){
        get_plan_groups_response res = new get_plan_groups_response();             
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        validateResponse(data);
        res.error_code = error_cd;
        res.error_msg = error_msg;
        if(error_cd != 0) {
           return res; 
        } 
        if(mainStruct.get('plan_groups') != null){
            WDDXVariable plan_groups_var = mainStruct.get('plan_groups');
            WDDXArray plan_groups_arr = (WDDXArray)plan_groups_var.item;
            WDDXStruct plan_groups_strct;
            plan_group obj_plan_groups;
            for(WDDXItem itm :  plan_groups_arr.items){
                obj_plan_groups = new plan_group();
                plan_groups_strct = (WDDXStruct)itm;
                obj_plan_groups.group_no =  getIntVal(plan_groups_strct.get('group_no'));
                obj_plan_groups.group_name =  getStrVal(plan_groups_strct.get('group_name'));
                obj_plan_groups.group_desc =  getStrVal(plan_groups_strct.get('group_desc'));
                obj_plan_groups.client_plan_change_group_id =  getStrVal(plan_groups_strct.get('client_plan_change_group_id'));
                obj_plan_groups.group_usage =  getStrVal(plan_groups_strct.get('group_usage'));
                obj_plan_groups.group_plans_count = getIntVal(plan_groups_strct.get('group_plans_count'));
                res.plan_groups.add(obj_plan_groups);   
            }
        }
        return res;
    }
    
    //Rakesh-- response handler for get_plans
    public static get_plans_response handle_get_plans(WDDXData data){
        get_plans_response res = new get_plans_response();             
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        validateResponse(data);
        res.error_code = error_cd;
        res.error_msg = error_msg;
        if(error_cd != 0) {
           return res; 
        } 
        if(mainStruct.get('plans') != null){
            WDDXVariable plans_var = mainStruct.get('plans');
            WDDXArray plans_arr = (WDDXArray)plans_var.item;
            WDDXStruct plans_strct; 
            plan obj_plans;
            for(WDDXItem itm :  plans_arr.items){
                obj_plans = new plan();
                plans_strct = (WDDXStruct)itm;
                obj_plans.plan_no =  getIntVal(plans_strct.get('plan_no'));
                obj_plans.plan_name =  getStrVal(plans_strct.get('plan_name'));
                obj_plans.plan_level =  getIntVal(plans_strct.get('plan_level'));
                obj_plans.client_plan_id =  getStrVal(plans_strct.get('client_plan_id'));
                obj_plans.billing_interval =  getIntVal(plans_strct.get('billing_interval'));
                obj_plans.active_ind = getIntVal(plans_strct.get('active_ind'));
                res.plans.add(obj_plans);   
            }
        }
        return res;
    }
    
    //Rakesh-- response handler for get_plan_service_details
    public static get_plan_service_details_response handle_get_plan_service_details(WDDXData data){
        get_plan_service_details_response res = new get_plan_service_details_response();             
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        validateResponse(data);
        res.error_code = error_cd;
        res.error_msg = error_msg;
        if(error_cd != 0) {
           return res; 
        } 
        res.plan_no =  getStrVal(mainStruct.get('plan_no'));  
        res.currency_cd =  getStrVal(mainStruct.get('currency_cd'));
        res.service_no =  getStrVal(mainStruct.get('service_no'));
        res.service_name =  getStrVal(mainStruct.get('service_name'));
        res.service_type =  getStrVal(mainStruct.get('service_type'));
        res.client_service_id =  getStrVal(mainStruct.get('client_service_id'));
        res.taxable_ind =  getIntVal(mainStruct.get('taxable_ind'));
        res.tax_group =  getStrVal(mainStruct.get('tax_group'));
        res.client_tax_group_id =  getStrVal(mainStruct.get('client_tax_group_id'));
        res.gl_cd =  getStrVal(mainStruct.get('gl_cd'));
        res.usage_type =  getIntVal(mainStruct.get('usage_type'));
        res.rate_type =  getStrVal(mainStruct.get('rate_type'));
        
        if(mainStruct.get('rate_schedules') != null){
            WDDXVariable rate_schedules_var = mainStruct.get('rate_schedules');
            WDDXArray rate_schedules_arr = (WDDXArray)rate_schedules_var.item;
            WDDXStruct rate_schedules_strct; 
            rate_schedule obj_rate_schedules;
            for(WDDXItem itm :  rate_schedules_arr.items){
                obj_rate_schedules = new rate_schedule();
                rate_schedules_strct = (WDDXStruct)itm;
                obj_rate_schedules.currencies =  getStrVal(rate_schedules_strct.get('currency'));
                
                if(rate_schedules_strct.get('rate_info') != null){
                    WDDXVariable rate_infos_var = rate_schedules_strct.get('rate_info');
                    WDDXArray rate_infos_arr = (WDDXArray)rate_infos_var.item;
                    WDDXStruct rate_infos_strct; 
                    rate_info obj_rate_infos;
                    for(WDDXItem itm1 : rate_infos_arr.items){
                        obj_rate_infos = new rate_info();
                        rate_infos_strct = (WDDXStruct)itm1;            
                        obj_rate_infos.schedule_no =  getIntVal(rate_infos_strct.get('schedule_no'));
                        obj_rate_infos.schedule_name =  getStrVal(rate_infos_strct.get('schedule_name'));
                        obj_rate_infos.client_rate_schedule_id =  getStrVal(rate_infos_strct.get('client_rate_schedule_id'));
                        obj_rate_infos.from_unit =  getIntVal(rate_infos_strct.get('from_unit'));
                        obj_rate_infos.to_unit =  getIntVal(rate_infos_strct.get('to_unit'));
                        obj_rate_infos.rate_per_unit =  getIntVal(rate_infos_strct.get('rate_per_unit'));
                        obj_rate_schedules.rate_infos.add(obj_rate_infos);
                    }
                }
                obj_rate_schedules.is_default =  getIntVal(rate_schedules_strct.get('is_default'));
                res.rate_schedules.add(obj_rate_schedules); 
            }
        }
        if(mainStruct.get('parent_plans') != null){
            WDDXVariable parent_plans_var = mainStruct.get('parent_plans');
            WDDXArray parent_plans_arr = (WDDXArray)parent_plans_var.item;
            WDDXStruct parent_plans_strct;
            for(WDDXItem itm :  parent_plans_arr.items){
                parent_plans_strct = (WDDXStruct)itm;
                res.parent_plans.add(getIntVal(parent_plans_strct.get('parent_plans'))); 
            }
        } 
        
        if(mainStruct.get('parent_plan_ids') != null){
            WDDXVariable parent_plan_ids_var = mainStruct.get('parent_plan_ids');
            WDDXArray parent_plan_ids_arr = (WDDXArray)parent_plan_ids_var.item;
            WDDXStruct parent_plan_ids_strct;
            for(WDDXItem itm :  parent_plan_ids_arr.items){
                parent_plan_ids_strct = (WDDXStruct)itm;
                res.parent_plan_ids.add(getIntVal(parent_plan_ids_strct.get('parent_plan_ids'))); 
            }
        } 
        
        if(mainStruct.get('exclusion_plans') != null){
            WDDXVariable exclusion_plans_var = mainStruct.get('exclusion_plans');
            WDDXArray exclusion_plans_arr = (WDDXArray)exclusion_plans_var.item;
            WDDXStruct exclusion_plans_strct;
            for(WDDXItem itm :  exclusion_plans_arr.items){
                exclusion_plans_strct = (WDDXStruct)itm;
                res.exclusion_plans.add(getIntVal(exclusion_plans_strct.get('exclusion_plans'))); 
            }
        }
         
        if(mainStruct.get('supplemental_obj_fields') != null){
            WDDXVariable supplemental_obj_fields_var = mainStruct.get('supplemental_obj_fields');
            WDDXArray supplemental_obj_fields_arr = (WDDXArray)supplemental_obj_fields_var.item;
            WDDXStruct supplemental_obj_fields_strct;
            for(WDDXItem itm :  supplemental_obj_fields_arr.items){
                supplemental_obj_fields_strct = (WDDXStruct)itm;
                res.supplemental_obj_fields.add(getStrVal(supplemental_obj_fields_strct.get('supplemental_obj_fields'))); 
            }
        } 
        return res; 
    }

    //Rakesh-- response handler for list_coa
    public static list_coa_response handle_list_coa(WDDXData data){
        list_coa_response res = new list_coa_response();             
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        validateResponse(data);
        res.error_code = error_cd;
        res.error_msg = error_msg;
        if(error_cd != 0) {
           return res; 
        } 
        if(mainStruct.get('coa') != null){
            WDDXVariable coa_lists_var = mainStruct.get('coa');
            WDDXArray coa_lists_arr = (WDDXArray)coa_lists_var.item;
            WDDXStruct coa_lists_strct; 
            coa_list obj_coa_lists;
            for(WDDXItem itm :  coa_lists_arr.items){
                obj_coa_lists = new coa_list();
                coa_lists_strct = (WDDXStruct)itm;
                obj_coa_lists.coa_id =  getIntVal(coa_lists_strct.get('coa_id'));
                obj_coa_lists.coa_code =  getStrVal(coa_lists_strct.get('coa_code'));
                obj_coa_lists.coa_description =  getStrVal(coa_lists_strct.get('coa_description'));
                res.coa_lists.add(obj_coa_lists);   
            }
        }
        return res;
    }
    
    // -- Mithilesh
    // response handler for get_services
    public static get_services_response handle_get_services(WDDXData data){
        get_services_response response = new get_services_response();             
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        validateResponse(data);
        response.error_code = error_cd;
        response.error_msg = error_msg;
        if(error_cd != 0) {
           return response;
        }
        WDDXVariable services = mainStruct.get('services');
        if(hasRecords(services)){
            WDDXArray servicesArr = (WDDXArray)services.item;
            WDDXStruct serviceStruct; 
            service ser;
            for(WDDXItem service_item : servicesArr.items) {
                ser = new service();
                serviceStruct = (WDDXStruct)service_item;
                
                ser.service_no = getLongVal(serviceStruct.get('service_no'));
                ser.service_name = getStrVal(serviceStruct.get('service_name'));
                ser.service_type = getStrVal(serviceStruct.get('service_type'));
                ser.client_service_id = getStrVal(serviceStruct.get('client_service_id'));
                
                response.services.add(ser);
            }
        }
        return response;
    }
    
    // response handler for get_service_types
    public static get_service_types_response handle_get_service_types(WDDXData data){
        get_service_types_response response = new get_service_types_response();             
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        validateResponse(data);
        response.error_code = error_cd;
        response.error_msg = error_msg;
        if(error_cd != 0) {
           return response;
        }
        WDDXVariable service_types = mainStruct.get('service_types');
        if(hasRecords(service_types)){
            WDDXArray service_typesArr = (WDDXArray)service_types.item;
            WDDXStruct service_typesStruct; 
            service_type ser_type;
            for(WDDXItem service_type_item : service_typesArr.items) {
                ser_type = new service_type();
                service_typesStruct = (WDDXStruct)service_type_item;
                
                ser_type.service_type_name = getStrVal(service_typesStruct.get('service_type_name'));
                ser_type.service_desc = getStrVal(service_typesStruct.get('service_desc'));
                
                response.service_types.add(ser_type);
            }
        }
        return response;
    }
    
    // response handler for get_service_details
    public static get_service_details_response handle_get_service_details(WDDXData data){
        get_service_details_response response = new get_service_details_response();             
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        validateResponse(data);
        response.error_code = error_cd;
        response.error_msg = error_msg;
        if(error_cd != 0) {
           return response;
        }
        
        response.service_no = getStrVal(mainStruct.get('service_no'));
        response.client_service_id = getStrVal(mainStruct.get('client_service_id'));
        response.service_name = getStrVal(mainStruct.get('service_name'));
        response.service_type = getStrVal(mainStruct.get('service_type'));
        response.gl_cd = getStrVal(mainStruct.get('gl_cd'));
        response.taxable_ind = getIntVal(mainStruct.get('taxable_ind'));
        response.tax_group = getStrVal(mainStruct.get('tax_group'));
        response.client_tax_group_id = getStrVal(mainStruct.get('client_tax_group_id'));
        response.usage_type = getIntVal(mainStruct.get('usage_type'));
        WDDXVariable supplemental_obj_fields = mainStruct.get('supplemental_obj_fields');
        if(hasRecords(supplemental_obj_fields)){
            WDDXArray supplemental_obj_fieldsArr = (WDDXArray)supplemental_obj_fields.item;
            for(WDDXItem supplemental_obj_fields_item : supplemental_obj_fieldsArr.items) {
                if(supplemental_obj_fields_item != WDDXNull.NIL){
                    response.supplemental_obj_fields.add(((WDDXString)supplemental_obj_fields_item).strValue);
                }
            }
        } 
        return response;
    }
    
    // response handler for get_recurring_credit_templates
    public static get_recurring_credit_templates_response handle_get_recurring_credit_templates(WDDXData data){
        get_recurring_credit_templates_response response = new get_recurring_credit_templates_response();             
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        validateResponse(data);
        response.error_code = error_cd;
        response.error_msg = error_msg;
        if(error_cd != 0) {
           return response;
        }
        WDDXVariable credit_templates = mainStruct.get('credit_templates');
        if(hasRecords(credit_templates)){
            WDDXArray credit_templatesArr = (WDDXArray)credit_templates.item;
            WDDXStruct credit_templateStruct; 
            rec_credit_template cred_template;
            for(WDDXItem credit_template_item : credit_templatesArr.items) {
                cred_template = new rec_credit_template();
                credit_templateStruct = (WDDXStruct)credit_template_item;
                
                cred_template.recurring_credit_template_no = getLongVal(credit_templateStruct.get('recurring_credit_template_no'));
                cred_template.credit_template_name = getStrVal(credit_templateStruct.get('credit_template_name'));
                cred_template.client_credit_template_id = getStrVal(credit_templateStruct.get('client_credit_template_id'));
                                
                response.credit_templates.add(cred_template);
            }
        }
        return response;
    }
    
    /// ----------------------admin tool handler start dileep -------------------
    public static get_promo_plan_set_details_response handle_get_promo_plan_set_details(WDDXData data){
        get_promo_plan_set_details_response rsp = new get_promo_plan_set_details_response();
        validateResponse(data);
        rsp.error_code = error_cd;
        rsp.error_msg = error_msg;
        if(error_cd != 0) {
           return rsp;
        }
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        rsp.promo_plan_set_no = getLongVal(mainStruct.get('promo_plan_set_no'));
        rsp.promo_plan_set_name = getStrVal(mainStruct.get('promo_plan_set_name'));
        rsp.promo_plan_set_desc = getStrVal(mainStruct.get('promo_plan_set_desc'));
        rsp.client_plan_type_id = getStrVal(mainStruct.get('client_plan_type_id'));
        WDDXVariable planStrct = mainStruct.get('plan');
        if(hasRecords(planStrct)){
            WDDXArray planStrctarr = (WDDXArray)planStrct.item;
            Plan1 plan ;
            for(WDDXItem itm : planStrctarr.items) {
                WDDXStruct planStct =  (WDDXStruct)itm;
                plan = new Plan1();
                plan.plan_no =  getLongVal(planStct.get('plan_no'));
                plan.plan_name =  getStrVal(planStct.get('plan_name'));
                plan.plan_desc =  getStrVal(planStct.get('plan_desc'));
                plan.client_plan_id =  getStrVal(planStct.get('client_plan_id'));
                rsp.plans.add(plan);
            }
        }   
        return rsp;
    }
    public static get_promo_plan_sets_response handle_get_promo_plan_sets(WDDXData data){
        get_promo_plan_sets_response rsp = new get_promo_plan_sets_response();
        validateResponse(data);
        rsp.error_code = error_cd;
        rsp.error_msg = error_msg;
        if(error_cd != 0) {
           return rsp;
        }
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        WDDXVariable promo_plan_set_strct = mainStruct.get('promo_plan_set');
        if(hasRecords(promo_plan_set_strct)){
            WDDXArray promo_plan_set_arr = (WDDXArray)promo_plan_set_strct.item;
            promo_plan_set promo_set ;
            for(WDDXItem itm : promo_plan_set_arr.items) {
                WDDXStruct pln_promo_set_strct =  (WDDXStruct)itm;
                promo_set = new promo_plan_set();
                promo_set.promo_plan_set_no =  getLongVal(pln_promo_set_strct.get('promo_plan_set_no'));
                promo_set.promo_plan_set_name =  getStrVal(pln_promo_set_strct.get('promo_plan_set_name'));
                promo_set.promo_plan_set_desc =  getStrVal(pln_promo_set_strct.get('promo_plan_set_desc'));
                promo_set.client_plan_type_id =  getStrVal(pln_promo_set_strct.get('client_plan_type_id'));
                rsp.promo_plan_sets.add(promo_set);
            }
        }
        return rsp;
    }  
    public static get_promotions_response handle_get_promotions(WDDXData data){
        get_promotions_response rsp = new get_promotions_response();
        validateResponse(data);
        rsp.error_code = error_cd;
        rsp.error_msg = error_msg;
        if(error_cd != 0) {
           return rsp;
        }
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        WDDXVariable promotions_strct = mainStruct.get('promotions');
        if(hasRecords(promotions_strct)){
            WDDXArray promotions_arr = (WDDXArray)promotions_strct.item;
            promotion prtn ;
            for(WDDXItem itm : promotions_arr.items) {
                WDDXStruct pln_promo_set_strct =  (WDDXStruct)itm;
                prtn = new promotion();
                prtn.promo_cd =  getStrVal(pln_promo_set_strct.get('promo_cd'));
                prtn.promo_desc =  getStrVal(pln_promo_set_strct.get('promo_desc'));
                prtn.expires_after =  getStrVal(pln_promo_set_strct.get('expires_after'));
                rsp.promotions.add(prtn);
            }
        }
        return rsp;
    }
    public static get_recurring_credit_template_details_response handle_get_recurring_credit_template_details(WDDXData data){
        get_recurring_credit_template_details_response rsp = new get_recurring_credit_template_details_response();
        validateResponse(data);
        rsp.error_code = error_cd;
        rsp.error_msg = error_msg;
        if(error_cd != 0) {
           return rsp;
        }
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        
        rsp.credit_template_id = getIntVal(mainStruct.get('credit_template_id'));
        rsp.credit_template_name = getStrVal(mainStruct.get('credit_template_name'));
        rsp.client_credit_template_id = getStrVal(mainStruct.get('client_credit_template_id'));
        rsp.eligible_plan_no = getLongVal(mainStruct.get('eligible_plan_no'));
        rsp.eligible_client_plan_id = getStrVal(mainStruct.get('eligible_client_plan_id'));
        rsp.eligible_service_no = getLongVal(mainStruct.get('eligible_service_no'));
        rsp.eligible_client_service_id = getStrVal(mainStruct.get('eligible_client_service_id'));

        if(mainStruct.get('eligible_service_types')!=null){
            WDDXVariable eligible_service_types_var = mainStruct.get('eligible_service_types');
            if(eligible_service_types_var != null){
                WDDXArray eligible_service_types_arr = (WDDXArray)eligible_service_types_var.item;
                for(WDDXItem itm :  eligible_service_types_arr.items){
                    rsp.eligible_service_types.add(((WDDXString)itm).strValue);
                }
            }
        }
        
        rsp.no_of_credits = getIntVal(mainStruct.get('no_of_credits'));
        rsp.time_between_credits = getIntVal(mainStruct.get('time_between_credits'));
        rsp.discount_type = getStrVal(mainStruct.get('discount_type'));
        rsp.discount_amt = getDeciVal(mainStruct.get('discount_amt'));
        rsp.percentage_plan_no = getLongVal(mainStruct.get('percentage_plan_no'));
        rsp.percentage_client_plan_id = getStrVal(mainStruct.get('percentage_client_plan_id'));
        rsp.percentage_service_no = getLongVal(mainStruct.get('percentage_service_no'));
        rsp.percentage_client_service_id = getStrVal(mainStruct.get('percentage_client_service_id'));
        rsp.alt_service_no = getLongVal(mainStruct.get('alt_service_no'));
        rsp.alt_client_service_id = getStrVal(mainStruct.get('alt_client_service_id'));

        WDDXVariable couponsStrct = mainStruct.get('coupons');
        if(hasRecords(couponsStrct)){
            WDDXArray couponsStrctarr = (WDDXArray)couponsStrct.item;
            coupon obj_coupon ;
            for(WDDXItem itm : couponsStrctarr.items) {
                WDDXStruct couponStct =  (WDDXStruct)itm;
                obj_coupon = new coupon();
                obj_coupon.coupon_cd =  getStrVal(couponStct.get('coupon_cd'));
                obj_coupon.coupon_desc =  getStrVal(couponStct.get('coupon_desc'));
                obj_coupon.coupon_msg =  getStrVal(couponStct.get('coupon_msg'));
                obj_coupon.start_date =  getStrVal(couponStct.get('start_date'));
                obj_coupon.end_date =  getStrVal(couponStct.get('end_date'));
                obj_coupon.status_ind  =  getIntVal(couponStct.get('status_ind'));
                obj_coupon.no_of_uses =  getIntVal(couponStct.get('no_of_uses'));
                rsp.coupons.add(obj_coupon);
            }
        }   
        return rsp;
    }
    
    // --------------------------------- Casino End-------------------------------
    //-----CityLights-----
    public static get_usage_unit_types_response handle_get_usage_unit_types(WDDXData data){
        get_usage_unit_types_response rsp = new get_usage_unit_types_response();
        validateResponse(data);
        rsp.error_code = error_cd;
        rsp.error_msg = error_msg;
        if(error_cd != 0) {
           return rsp;
        }
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        WDDXVariable usg_unt_typ_strct = mainStruct.get('usage_unit_types');
        if(hasRecords(usg_unt_typ_strct)){
            WDDXArray usg_unt_typ_arr = (WDDXArray)usg_unt_typ_strct.item;
            usage_unit_type usg_typ ;
            for(WDDXItem itm : usg_unt_typ_arr.items) {
                WDDXStruct usg_strct =  (WDDXStruct)itm;
                usg_typ = new usage_unit_type();
                usg_typ.usage_unit_type_no =  getIntVal(usg_strct.get('usage_unit_type_no'));
                usg_typ.usage_unit_type_desc =  getStrVal(usg_strct.get('usage_unit_type_desc'));
                usg_typ.client_usage_unit_type_id =  getStrVal(usg_strct.get('client_usage_unit_type_id'));
                rsp.usage_unit_types.add(usg_typ);
            }
        }
        return rsp;
    }
    
    public static copy_plan_response handle_copy_plan(WDDXData data){
        copy_plan_response rsp = new copy_plan_response();
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        rsp.error_code = integer.valueOf(getStrVal(mainStruct.get('error_code')));
        rsp.error_msg = getStrVal(mainStruct.get('error_msg'));
        if(error_cd != 0) {
           return rsp;
        }
        
        rsp.plan_no  = getLongVal(mainStruct.get('plan_no'));
        return rsp;
    }
    
    public static create_coupon_response handle_create_coupon(WDDXData data){
        create_coupon_response rsp = new create_coupon_response();
        validateResponse(data);
        rsp.error_code = error_cd;
        rsp.error_msg = error_msg;
        if(error_cd != 0) {
           return rsp;
        }
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        rsp.coupon_cd  = getStrVal(mainStruct.get('coupon_cd'));
        return rsp;
    }
    
    public static create_credit_template_response handle_create_credit_template(WDDXData data){
        create_credit_template_response rsp = new create_credit_template_response();
        validateResponse(data);
        rsp.error_code = error_cd;
        rsp.error_msg = error_msg;
        if(error_cd != 0) {
           return rsp;
        }
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        rsp.credit_template_no  = getLongVal(mainStruct.get('credit_template_no'));
        return rsp;
    }
    
    public static create_discount_bundle_response handle_create_discount_bundle(WDDXData data){
        create_discount_bundle_response rsp = new create_discount_bundle_response();
        validateResponse(data);
        rsp.error_code = error_cd;
        rsp.error_msg = error_msg;
        if(error_cd != 0) {
           return rsp;
        }
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        rsp.rule_no  = getStrVal(mainStruct.get('rule_no'));
        return rsp;
    }
    
    // response handler for get_supp_field_details
    public static get_supp_field_details_response handle_get_supp_field_details(WDDXData data){
        get_supp_field_details_response response = new get_supp_field_details_response();             
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        validateResponse(data);
        response.error_code = error_cd;
        response.error_msg = error_msg;
        if(error_cd != 0) {
           return response;
        }
        
        response.field_name = getStrVal(mainStruct.get('field_name'));
        response.field_desc = getStrVal(mainStruct.get('field_desc'));
        response.field_order = getIntVal(mainStruct.get('field_order'));
        response.required_ind = getIntVal(mainStruct.get('required_ind'));
        response.hidden_ind = getIntVal(mainStruct.get('hidden_ind'));
        response.sel_ind = getIntVal(mainStruct.get('sel_ind'));
        response.presentation_mode = getStrVal(mainStruct.get('presentation_mode'));
        response.min_no_sel = getIntVal(mainStruct.get('min_no_sel'));
        response.max_no_sel = getIntVal(mainStruct.get('max_no_sel'));
        response.additional_html = getStrVal(mainStruct.get('additional_html'));
        response.extra_validation_methods = getStrVal(mainStruct.get('extra_validation_methods'));
        
        WDDXVariable field_options = mainStruct.get('field_options');
        if(hasRecords(field_options)){
            WDDXArray field_optionsArr = (WDDXArray)field_options.item;
            WDDXStruct field_optionStruct; 
            field_option fld_opt;
            for(WDDXItem field_option_item : field_optionsArr.items) {
                fld_opt = new field_option();
                field_optionStruct = (WDDXStruct)field_option_item;
                
                fld_opt.display_text = getStrVal(field_optionStruct.get('display_text'));
                fld_opt.option_value = getStrVal(field_optionStruct.get('option_value'));
                fld_opt.field_order = getIntVal(field_optionStruct.get('field_order'));
                        
                response.field_options.add(fld_opt);
            }
        }
        WDDXVariable sel_options = mainStruct.get('sel_options');
        if(hasRecords(sel_options)){
            WDDXArray sel_optionsArr = (WDDXArray)sel_options.item;
            WDDXStruct sel_optionStruct; 
            sel_option sel_opt;
            for(WDDXItem sel_option_item : sel_optionsArr.items) {
                sel_opt = new sel_option();
                sel_optionStruct = (WDDXStruct)sel_option_item;
                
                sel_opt.display_text = getStrVal(sel_optionStruct.get('display_text'));
                sel_opt.option_value = getStrVal(sel_optionStruct.get('option_value'));
                sel_opt.option_value_order = getIntVal(sel_optionStruct.get('option_value_order'));
                        
                response.sel_options.add(sel_opt);
            }
        }
        return response;
    }
    
    // response handler for get_supp_fields
    public static get_supp_fields_response handle_get_supp_fields(WDDXData data){
        get_supp_fields_response response = new get_supp_fields_response();             
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        validateResponse(data);
        response.error_code = error_cd;
        response.error_msg = error_msg;
        if(error_cd != 0) {
           return response;
        }
        WDDXVariable supp_fields = mainStruct.get('supp_fields');
        if(hasRecords(supp_fields)){
            WDDXArray supp_fieldsArr = (WDDXArray)supp_fields.item;
            WDDXStruct supp_fieldStruct; 
            supp_field supp_fld;
            for(WDDXItem supp_field_item : supp_fieldsArr.items) {
                supp_fld = new supp_field();
                supp_fieldStruct = (WDDXStruct)supp_field_item;
                
                supp_fld.field_name = getStrVal(supp_fieldStruct.get('field_name'));
                supp_fld.field_desc = getStrVal(supp_fieldStruct.get('field_desc'));
                supp_fld.field_order = getIntVal(supp_fieldStruct.get('field_order'));
                        
                response.supp_fields.add(supp_fld);
            }
        }
        return response;
    }
    
    // response handler for get_supp_obj_fields
    public static get_supp_obj_fields_response handle_get_supp_obj_fields(WDDXData data){
        get_supp_obj_fields_response response = new get_supp_obj_fields_response();             
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        validateResponse(data);
        response.error_code = error_cd;
        response.error_msg = error_msg;
        if(error_cd != 0) {
           return response;
        }
        
        response.field_no = getLongVal(mainStruct.get('field_no'));
        response.field_name = getStrVal(mainStruct.get('field_name'));
        response.description = getStrVal(mainStruct.get('description'));
        response.datatype = getStrVal(mainStruct.get('datatype'));
        response.min_no_sel = getLongVal(mainStruct.get('min_no_sel'));
        response.max_no_sel = getLongVal(mainStruct.get('max_no_sel'));
        response.form_input_type = getStrVal(mainStruct.get('form_input_type'));
        
        
        WDDXVariable allowed_values = mainStruct.get('allowed_values');
        if(hasRecords(allowed_values)){
            WDDXArray allowed_valuesArr = (WDDXArray)allowed_values.item;
            for(WDDXItem allowed_values_item : allowed_valuesArr.items) {
                if(allowed_values_item != WDDXNull.NIL){
                    response.allowed_values.add(((WDDXString)allowed_values_item).strValue);
                }
            }
        } 
        WDDXVariable associated_objects = mainStruct.get('associated_objects');
        if(associated_objects!= null && associated_objects.item != WDDXNull.NIL){
            WDDXStruct associated_objectsStruct = (WDDXStruct)associated_objects.item;
            /*
            at the time of development we have only four object type as below but being safer side I am taking loop limit to 10 instead of 4 as if some
            more object type added to the product field in future it will be able to handle upto 10
            "1": "Plan","2": "Inventory Item", "3": "Service Code", "4": "Usage Type"
            */
            WDDXVariable tempVar;
            for(integer i=1; i<=10; i++) {
                tempVar = associated_objectsStruct.get(''+i);
                if(tempVar != null && tempVar.item != WDDXNull.NIL){
                    response.associated_objects.add(((WDDXString)tempVar.item).strValue);
                }
                
            }
        } 
        return response;
    }
    
    // response handler for get_usage_type_details
    public static get_usage_type_details_response handle_get_usage_type_details(WDDXData data){
        get_usage_type_details_response response = new get_usage_type_details_response();             
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        validateResponse(data);
        response.error_code = error_cd;
        response.error_msg = error_msg;
        if(error_cd != 0) {
           return response;
        }
        
        response.usage_type_no = getLongVal(mainStruct.get('usage_type_no'));
        response.usage_type_name = getStrVal(mainStruct.get('usage_type_name'));
        response.usage_type_desc = getStrVal(mainStruct.get('usage_type_desc'));
        response.usage_type_display_string = getStrVal(mainStruct.get('usage_type_display_string'));
        response.usage_type_code = getStrVal(mainStruct.get('usage_type_code'));
        response.usage_type_cd = getStrVal(mainStruct.get('usage_type_cd'));
        response.usage_unit_type = getStrVal(mainStruct.get('usage_unit_type'));
        response.client_usage_unit_type_id = getStrVal(mainStruct.get('client_usage_unit_type_id'));
        response.is_editable = getBoolVal(mainStruct.get('is_editable'));
        WDDXVariable supplemental_obj_fields = mainStruct.get('supplemental_obj_fields');
        if(hasRecords(supplemental_obj_fields)){
            WDDXArray supplemental_obj_fieldsArr = (WDDXArray)supplemental_obj_fields.item;
            for(WDDXItem supplemental_obj_fields_item : supplemental_obj_fieldsArr.items) {
                if(supplemental_obj_fields_item != WDDXNull.NIL){
                    response.supplemental_obj_fields.add(((WDDXString)supplemental_obj_fields_item).strValue);
                }
            }
        } 
        
        return response;
    }
    
    // response handler for get_usage_types
    public static get_usage_types_response handle_get_usage_types(WDDXData data){
        get_usage_types_response response = new get_usage_types_response();             
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        validateResponse(data);
        response.error_code = error_cd;
        response.error_msg = error_msg;
        if(error_cd != 0) {
           return response;
        }
        WDDXVariable usage_types = mainStruct.get('usage_types');
        if(hasRecords(usage_types)){
            WDDXArray usage_typesArr = (WDDXArray)usage_types.item;
            WDDXStruct usage_typeStruct; 
            usage_type usg_type;
            for(WDDXItem usage_type_item : usage_typesArr.items) {
                usg_type = new usage_type();
                usage_typeStruct = (WDDXStruct)usage_type_item;
                
                usg_type.usage_type_no = getLongVal(usage_typeStruct.get('usage_type_no'));
                usg_type.usage_type_name = getStrVal(usage_typeStruct.get('usage_type_name'));
                usg_type.usage_type_desc = getStrVal(usage_typeStruct.get('usage_type_desc'));
                usg_type.unit_type = getStrVal(usage_typeStruct.get('unit_type'));
                usg_type.usage_type_cd = getStrVal(usage_typeStruct.get('usage_type_cd'));
                usg_type.is_editable = getBoolVal(usage_typeStruct.get('is_editable'));
                            
                response.usage_types.add(usg_type);
            }
        }
        return response;
    }
    
    //Rakesh - response handler for list_promo_sets
    public static list_promo_sets_response handle_list_promo_sets(WDDXData data){
        list_promo_sets_response rsp = new list_promo_sets_response();
        validateResponse(data);
        rsp.error_code = error_cd;
        rsp.error_msg = error_msg;
        if(error_cd != 0) {
           return rsp;
        }
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        WDDXVariable promo_plan_set_strct = mainStruct.get('promo_plan_set');
        if(hasRecords(promo_plan_set_strct)){
            WDDXArray promo_plan_set_arr = (WDDXArray)promo_plan_set_strct.item;
            list_promo_plan_set lpps ;
            for(WDDXItem itm : promo_plan_set_arr.items) {
                WDDXStruct pln_promo_set_strct =  (WDDXStruct)itm;
                lpps = new list_promo_plan_set();
                lpps.plan_set_no =  getIntVal(pln_promo_set_strct.get('plan_set_no'));
                lpps.set_name =  getStrVal(pln_promo_set_strct.get('set_name'));
                lpps.set_description =  getStrVal(pln_promo_set_strct.get('set_description'));
                lpps.client_plan_type_id =  getStrVal(pln_promo_set_strct.get('client_plan_type_id'));
                rsp.list_promo_plan_sets.add(lpps);
            }
        }
        return rsp;
    }
    
    //create_item_class
    public static create_item_class_response handle_create_item_class(WDDXData data){
        create_item_class_response rsp = new create_item_class_response();
        validateResponse(data);
        rsp.error_code = error_cd;
        rsp.error_msg = error_msg;
        if(error_cd != 0) {
           return rsp;
        }
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        rsp.class_no  = getLongVal(mainStruct.get('class_no'));
        return rsp;
    }
    
    //reate_inventory_item_
    public static create_inventory_item_response handle_create_inventory_item(WDDXData data){
        create_inventory_item_response rsp = new create_inventory_item_response();
        validateResponse(data);
        rsp.error_code = error_cd;
        rsp.error_msg = error_msg;
        if(error_cd != 0) {
           return rsp;
        }
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        rsp.item_no  = getLongVal(mainStruct.get('item_no'));
        return rsp;
    }
    
    //create_plan_group
    public static create_discount_rule_response handle_create_discount_rule(WDDXData data){
        create_discount_rule_response rsp = new create_discount_rule_response();
        validateResponse(data);
        rsp.error_code = error_cd;
        rsp.error_msg = error_msg;
        if(error_cd != 0) {
           return rsp;
        }
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        rsp.rule_no  = getStrVal(mainStruct.get('rule_no'));
        return rsp;
    }
    
    //update_usage_type
    public static update_usage_type_response handle_update_usage_type(WDDXData data){
        update_usage_type_response rsp = new update_usage_type_response();
        validateResponse(data);
        rsp.error_code = error_cd;
        rsp.error_msg = error_msg;
        if(error_cd != 0) {
           return rsp;
        }
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        rsp.usage_type_no  = getLongVal(mainStruct.get('usage_type_no'));
        return rsp;
    }
    
    //------------------EasyRider Sprint-----------------------------------------
    
    //create_plan_group
    public static create_plan_group_response handle_create_plan_group(WDDXData data){
        create_plan_group_response rsp = new create_plan_group_response();
        validateResponse(data);
        rsp.error_code = error_cd;
        rsp.error_msg = error_msg;
        if(error_cd != 0) {
           return rsp;
        }
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        rsp.group_no  = getLongVal(mainStruct.get('group_no'));
        return rsp;
    }
    
    //create_promo_plan_set
    public static create_promo_plan_set_response handle_create_promo_plan_set(WDDXData data){
        create_promo_plan_set_response rsp = new create_promo_plan_set_response();
        validateResponse(data);
        rsp.error_code = error_cd;
        rsp.error_msg = error_msg;
        if(error_cd != 0) {
           return rsp;
        }
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        rsp.promo_plan_set_no  = getLongVal(mainStruct.get('promo_plan_set_no'));
        return rsp;
    }
    
       //create_promotion
    public static create_promotion_response handle_create_promotion(WDDXData data){
        create_promotion_response rsp = new create_promotion_response();
        validateResponse(data);
        rsp.error_code = error_cd;
        rsp.error_msg = error_msg;
        if(error_cd != 0) {
           return rsp;
        }
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        rsp.promo_cd  = getStrVal(mainStruct.get('promo_cd'));
        return rsp;
    }
       //create_service
    public static create_service_response handle_create_service(WDDXData data){
        create_service_response rsp = new create_service_response();
        validateResponse(data);
        rsp.error_code = error_cd;
        rsp.error_msg = error_msg;
        if(error_cd != 0) {
           return rsp;
        }
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        rsp.service_no  = getLongVal(mainStruct.get('service_no'));
        return rsp;
    }
       //create_supp_field
    public static create_supp_field_response handle_create_supp_field(WDDXData data){
        create_supp_field_response rsp = new create_supp_field_response();
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        try{
            rsp.error_code = integer.valueOf(getStrVal(mainStruct.get('error_code')));
        }catch(Exception ex){
            rsp.error_code = getIntVal(mainStruct.get('error_code'));
        }
        rsp.error_msg = getStrVal(mainStruct.get('error_msg'));
        if(rsp.error_code != 0) {
           return rsp;
        }
        rsp.field_name  = getStrVal(mainStruct.get('field_name'));
        return rsp;
    }
    
    
       //create_usage_type
    public static create_usage_type_response handle_create_usage_type(WDDXData data){
        create_usage_type_response rsp = new create_usage_type_response();
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        try{
            rsp.error_code = integer.valueOf(getStrVal(mainStruct.get('error_code')));
        }catch(Exception ex){
            rsp.error_code = getIntVal(mainStruct.get('error_code'));
        }
        rsp.error_msg = getStrVal(mainStruct.get('error_msg'));
        if(rsp.error_code != 0) {
           return rsp;
        }
        rsp.usage_type_no  = getLongVal(mainStruct.get('usage_type_no'));
        return rsp;
    }
    
    //-------------Rakesh---------------
    //delete_bundles
    public static delete_bundles_response handle_delete_bundles(WDDXData data){
        delete_bundles_response rsp = new delete_bundles_response();
        validateResponse(data);
        rsp.error_code = error_cd;
        rsp.error_msg = error_msg;
        if(error_cd != 0) {
           return rsp;
        }
        return rsp;
    }
    
    //delete_coupons
    public static delete_coupons_response handle_delete_coupons(WDDXData data){
        delete_coupons_response rsp = new delete_coupons_response();
        validateResponse(data);
        rsp.error_code = error_cd;
        rsp.error_msg = error_msg;
        if(error_cd != 0) {
           return rsp;
        }
        return rsp;
    } 
    
   // delete_plan_group
    public static delete_plan_group_response handle_delete_plan_group(WDDXData data){
        delete_plan_group_response res = new delete_plan_group_response();             
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        validateResponse(data);
        res.error_code = error_cd;
        res.error_msg = error_msg;
        if(error_cd != 0) {
           return res; 
        } 
        if(mainStruct.get('plan_groups') != null){
            WDDXVariable plan_groups_var = mainStruct.get('plan_groups');
            WDDXArray plan_groups_arr = (WDDXArray)plan_groups_var.item;
            WDDXStruct plan_groups_strct; 
            plan_group obj_plan_groups;
            for(WDDXItem itm :  plan_groups_arr.items){
                obj_plan_groups = new plan_group();
                plan_groups_strct = (WDDXStruct)itm;
                obj_plan_groups.group_no =  getIntVal(plan_groups_strct.get('group_no'));
                obj_plan_groups.group_name =  getStrVal(plan_groups_strct.get('group_name'));
                res.plan_groups.add(obj_plan_groups);   
            }
        }
        return res;
    }
   
    // delete_plans
    public static delete_plans_response handle_delete_plans(WDDXData data){
        delete_plans_response res = new delete_plans_response();             
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        validateResponse(data);
        res.error_code = error_cd;
        res.error_msg = error_msg;
        if(error_cd != 0) {
           return res; 
        } 
        if(mainStruct.get('plans') != null){
            WDDXVariable plans_var = mainStruct.get('plans');
            WDDXArray plans_arr = (WDDXArray)plans_var.item;
            WDDXStruct plans_strct; 
            plan obj_plans;
            for(WDDXItem itm :  plans_arr.items){
                obj_plans = new plan();
                plans_strct = (WDDXStruct)itm;
                obj_plans.plan_no =  getIntVal(plans_strct.get('plan_no'));
                obj_plans.plan_name =  getStrVal(plans_strct.get('plan_name'));
                res.plans.add(obj_plans);   
            }
        }
        return res;
    }
    
    // delete_rules
    public static delete_rules_response handle_delete_rules(WDDXData data){
        delete_rules_response rsp = new delete_rules_response();
        validateResponse(data);
        rsp.error_code = error_cd;
        rsp.error_msg = error_msg;
        if(error_cd != 0) {
           return rsp;
        }
        return rsp;
    } 
    
    // delete_templates
    public static delete_templates_response handle_delete_templates(WDDXData data){
        delete_templates_response rsp = new delete_templates_response();
        validateResponse(data);
        rsp.error_code = error_cd;
        rsp.error_msg = error_msg;
        if(error_cd != 0) {
           return rsp;
        }
        return rsp;
    } 
    
    //update_credit_template
    public static update_credit_template_response handle_update_credit_template(WDDXData data){
        update_credit_template_response rsp = new update_credit_template_response();
        validateResponse(data);
        rsp.error_code = error_cd;
        rsp.error_msg = error_msg; 
        if(error_cd != 0) {
           return rsp;
        }
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        rsp.credit_template_no  = getLongVal(mainStruct.get('credit_template_no'));
        return rsp;
    }
    
    //create_new_plan
    public static create_new_plan_response handle_create_new_plan(WDDXData data){
        create_new_plan_response rsp = new create_new_plan_response();
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        validateResponse(data);
        //rsp.error_code = integer.valueOf(getStrVal(mainStruct.get('error_code')));
        //rsp.error_msg = getStrVal(mainStruct.get('error_msg'));
        rsp.error_code = error_cd;
        rsp.error_msg = error_msg; 
        if(error_cd != 0) {
           return rsp;
        }

        rsp.plan_no  = getLongVal(mainStruct.get('plan_no'));
        return rsp;
    }
    
    //create_new_plan
    public static create_surcharge_response handle_create_surcharge(WDDXData data){
        create_surcharge_response rsp = new create_surcharge_response();
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        //validateResponse(data);
        string ec = getStrVal(mainStruct.get('error_code'));
        
        //rsp.error_code = integer.valueOf();
        rsp.error_msg = getStrVal(mainStruct.get('error_msg'));
        //rsp.error_code = error_cd;
        //rsp.error_msg = error_msg; 
            system.debug('>>>>>>>>>>>'+ec+ '     '+rsp.error_msg);
        if(error_cd != 0) {
           return rsp;
        }
    
        rsp.surcharge_no  = getStrVal(mainStruct.get('surcharge_no'));
        return rsp;
    }
}