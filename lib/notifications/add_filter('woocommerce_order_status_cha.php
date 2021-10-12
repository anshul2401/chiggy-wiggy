add_filter('woocommerce_order_status_changed','woocommerce_send_notification_to_customer', 10 , 4);
function woocommerce_send_notification_to_customer($order_id, $order_status, $new_status,$order){
	$user_id = $order->get_user_id();
	$user_info = get_user_meta($user_id);
	if($new_status == 'completed'){
		$fields['isAndroid'] =true;
		$fields['heading'] =array("en" => "Chiggy Wiggy");
		$fields['contents'] =array("en" => "Order out for Delivery");
		$fields['app_id'] ;
		$fields['include_player_ids'] =[$user_info['one_signal_id'][0]];
		$fields['data'] =array("order_id" => $order_id);
		$onesignal_post_url = "https://onesignal.com/api/v1/notifications";
		$onesignal_wp_settings = OneSignal::get_onesignal_setting();
		$onesignal_auth_key= $onesignal_wp_settings['app_rest_api_key'];
		$request = array("headers" => array("content-type"=> "application/json;charset=utf-8","Authorization" => "Basic ".$onesignal_auth_key),"body"=> json_encode($fields),"timeout" => 60);
		$response = wp_remote_post($onesignal_post_url, $request);
		
	}
}