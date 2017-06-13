<section class="content-header">
	<div class="row">
		<div class="col-md-3">
			<label class="label-header"><?=$judul?></label>
		</div>
	</div>
</section>
<section class="content">
	<div class="row">
		<div class="col-lg-12">
			<?php if($this->session->userdata($this->config->item('ses_message'))) {echo $this->session->userdata($this->config->item('ses_message')); $this->session->unset_userdata($this->config->item('ses_message')); } /*$date = date('Y-m-d'); $newdate = strtotime ('-1 month', strtotime($date)) ; $newdate = date('m', $newdate); echo $newdate;*/ ?>
			<div class="box box-primary">
				<div class="box-header">
					<i class="fa fa-recycle"></i>
					<h3 class="box-title">Input Tutup Buku</h3>
				</div>
				<div class="box-body">
					<form id="exmb" class="form-horizontal" autocomplete="off" method="post" action="<?=base_url('tutupbuku/proses')?>">
						<div class="form-group">
							<label class="control-label col-lg-2">Periode</label>
							<div class="col-lg-2">
								<select class="form-control selectnot" name="bulan">
									<?php for($i=1;$i<=12;$i++) {if($bulan==$i) {echo '<option value="'.$i.'" selected>'.bulan($i).'</option>'; } else {echo '<option value="'.$i.'">'.bulan($i).'</option>'; } } ?>
								</select>
							</div>
							<div class="col-lg-2">
								<select class="form-control selectnot" name="tahun">
									<?php for($i=2016;$i<=date('Y');$i++) {if($tahun==$i) {echo '<option value="'.$i.'" selected>'.$i.'</option>'; } else {echo '<option value="'.$i.'">'.$i.'</option>'; } } ?>
								</select>
							</div>
						</div>
						<div class="form-group">
							<div class="col-lg-2 col-lg-offset-2">
								<button name="btnproses" value="proses" class="btn btn-sm btn-success kunci" onclick="return confirm('Apakah anda yakin ingin melakukan proses tutup buku?')">Proses</button>
							</div>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
</section>
