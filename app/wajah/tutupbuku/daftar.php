<section class="content-header">
	<div class="row">
		<div class="col-md-3">
			<label class="label-header"><?=$judul?></label>
		</div>
		<div class="col-md-9">
			<div class="pull-right">
				<a href="<?=base_url('tutupbuku/proses')?>" class="btn btn-sm btn-success"><img src="<?=base_url('assets/resources/add.png');?>" /> Tambah</a>
			</div>
		</div>
	</div>
</section>
<section class="content">
	<div class="row">
		<div class="col-lg-12">
			<?php if($this->session->userdata($this->config->item('ses_message'))) {echo $this->session->userdata($this->config->item('ses_message')); $this->session->unset_userdata($this->config->item('ses_message')); } ?>
			<div class="box box-primary">
				<div class="box-header">
					<i class="fa fa-recycle"></i>
					<h3 class="box-title">Daftar Tutup Buku</h3>
				</div> <div class="box-body">
					<table width="100%" class="table table-striped table-bordered table-hover" id="dtcustomt">
						<thead>
							<th>Periode</th>
							<th>Dilakukan Oleh</th>
							<th>Tanggal Proses</th>
							<th>Rollback</th>
						</thead>
						<tbody>
							<?php foreach ($tutup as $b) {
								$tgl    = date_format(date_create($b->periode_tb_bulanan), 'm');
								$tg2    = date_format(date_create($b->periode_tb_bulanan), 'Y');
								$bulan  = bulan(intval($tgl)) . " " . $tg2;
								echo '<tr>';
								echo '<td width="15%" class="text-right">'.$bulan.'</td>';
								echo '<td>'.$b->nama.'</td>';
								echo '<td>'.$b->tgl_dibuat.'</td>';
								echo '<td width="10%" class="text-center" title="Rollback" data-toggle="tooltip"><a onclick="return confirm(\'Apakah Anda yakin ingin membatalkan tutup buku ?\')" href="'. base_url('tutupbuku/rollback/'.$b->kode_unik) .'"><img src="'.base_url('assets/resources/select.png').'" /></a></td>';
								echo '</tr>';
							} ?>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
</section>
