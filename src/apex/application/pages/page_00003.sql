prompt --application/pages/page_00003
begin
--   Manifest
--     PAGE: 00003
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_api.create_page(
 p_id=>3
,p_user_interface_id=>wwv_flow_api.id(12495499263265880052)
,p_name=>'Open Diagram'
,p_alias=>'OPEN-DIAGRAM'
,p_page_mode=>'MODAL'
,p_step_title=>'Open Diagram'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'F4A'
,p_last_upd_yyyymmddhh24miss=>'20201109104913'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(15685887570738649)
,p_plug_name=>'Button Holder'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12495606500823880260)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_03'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(12494270788368128245)
,p_plug_name=>'Form'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--textContent:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12495582446800880234)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(12494270465300128242)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(15685887570738649)
,p_button_name=>'OPEN'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--mobileHideLabel:t-Button--iconLeft:t-Button--padTop'
,p_button_template_id=>wwv_flow_api.id(12495521691135880126)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Open'
,p_button_position=>'BELOW_BOX'
,p_icon_css_classes=>'fa-folder-o'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12494270661565128244)
,p_name=>'P3_DGRM_ID'
,p_is_required=>true
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(12494270788368128245)
,p_prompt=>'Diagram'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'DIAGRAMS'
,p_lov_display_null=>'YES'
,p_lov_null_text=>'- select -'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(12495522548744880132)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(12493547841507486141)
,p_name=>'Reload List'
,p_event_sequence=>20
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(12493547756449486140)
,p_event_id=>wwv_flow_api.id(12493547841507486141)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P3_DGRM_ID'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(15683048938738621)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_CLOSE_WINDOW'
,p_process_name=>'Close Dialog'
,p_attribute_01=>'P3_DGRM_ID'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
