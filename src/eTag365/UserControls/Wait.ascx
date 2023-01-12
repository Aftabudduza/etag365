<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Wait.ascx.cs" Inherits="eTag365.UserControls.Wait" %>
 <div class="modal fade" id="pleaseWait" tabindex="-1" role="dialog" aria-labelledby="pleaseWaitLabel" data-backdrop="static">
        <div class="modal-dialog modal-sm" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <span class="modal-title" id="pleaseWaitLabel"><span class="glyphicon glyphicon-time"></span>&nbsp;Please Wait</span>
                </div>
                <div class="progress">
                    <div class="progress-bar progress-bar-info progress-bar-striped active" style="width: 100%">
                    </div>
                </div>
            </div>
        </div>
    </div>