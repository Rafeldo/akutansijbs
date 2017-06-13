<!DOCTYPE html>
<html >
<head>
  <meta charset="UTF-8">
  <title>Flat Login Form</title>

  <link rel="stylesheet" href="<?=base_url('assets/login/css/reset.min.css')?>">

  <link rel='stylesheet prefetch' href='http://fonts.googleapis.com/css?family=Roboto:400,100,300,500,700,900'>
<link rel='stylesheet prefetch' href='http://fonts.googleapis.com/css?family=Montserrat:400,700'>
<link href="<?php echo base_url('assets/login/font-awesome-4.4.0/css/font-awesome.min.css'); ?>" rel="stylesheet">
      <link rel="icon" href="<?=base_url('assets/logons.png')?>">
      <link rel="stylesheet" href="<?=base_url('assets/login/css/style.css')?>">
		<link rel="stylesheet" href="<?=base_url('assets/dist/css/main.css')?>">
		<link rel="stylesheet" href="<?=base_url('assets/plugins/iCheck/square/blue.css')?>">


</head>

<body>

<div class="container">
  <div class="info">
    <h1>JBC Login Form</h1><span>Made with <i class="fa fa-heart"></i> by <a href="https://www.facebook.com/rafeldo.sulaiman">Rafeldo</a></span>
	 <?php if($this->session->userdata($this->config->item('ses_message'))) {echo $this->session->userdata($this->config->item('ses_message')); $this->session->unset_userdata($this->config->item('ses_message')); } ?>
  </div>
</div>


<div class="form">
   <div class="thumbnail"><img src="<?=base_url('assets/login/hat.svg')?>"/></div>
   <div class="login-form">
		<?php $attributes = array('method' => 'POST', 'autocomplete' => 'off');
	   echo form_open('', $attributes); ?>
		   <input type="text" name="your_email" class="form-control" placeholder="Email" />
		   <input type="password" name="your_password" class="form-control" placeholder="Kata Sandi "/>
		   <button type="submit" name="btnlogin" value="dologin" class="btn kunci btn-success btn-block btn-flat">Masuk</button>
		 <?php echo form_close(); //</form> ?>
	</div>

</div>
<video id="video" autoplay="autoplay" loop="loop" poster="polina.jpg">
  <source src="https://youtu.be/_cPlKqp8nEA" type="video/mp4"/>
</video>
	<script src="<?=base_url('assets/login/js/jquery-2.2.3.min.js') ?>"></script>
   <script src="<?php echo base_url('assets/login/jQuery/jQuery-2.1.3.min.js'); ?>"></script>
   <script src="<?=base_url('assets/login/js/index.js') ?>"></script>
	<script src="<?=base_url('assets/customnan/jquery.lock.min.js')?>"></script>
	<script src="<?=base_url('assets/plugins/iCheck/icheck.min.js')?>"></script>
 	<script src="<?=base_url('assets/customnan/jquery.lock.min.js')?>"></script>
	<script> $(function () {$('input').iCheck({checkboxClass: 'icheckbox_square-blue', radioClass: 'iradio_square-blue', increaseArea: '10%'}); $(".kunci").lock(); }); </script>

</body>
</html>
